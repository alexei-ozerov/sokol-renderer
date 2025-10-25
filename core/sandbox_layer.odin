package main

import "core:log"

import "vendor:stb/image"

import sg "../vendor/sokol/gfx"
import shelpers "../vendor/sokol/helpers"

import la "../library/app"
import lu "../library/util"


create_sprite :: proc(sprite_image_path: cstring) {
	// Load Image
	width, height, channels: i32
	pixels := image.load(sprite_image_path, &width, &height, &channels, 4)
	if pixels == nil {
		log.fatal("failed to load image")
	}

	img_desc := sg.Image_Desc {
		width = width,
		height = height,
		pixel_format = .RGBA8,
		data = {mip_levels = {0 = {ptr = pixels, size = uint(width * height * 4)}}},
	}
	state.sprite_render_pass.image = sg.make_image(img_desc)
	defer image.image_free(pixels) // TODO: (ozerova): Check if this needs to be cleaned up in cleanup_cb()

	// Create the view
	view_desc := sg.View_Desc {
		texture = {image = state.sprite_render_pass.image},
	}
	state.sprite_render_pass.view = sg.make_view(view_desc)

	// Create a sampler
	sampler_desc := sg.Sampler_Desc {
		min_filter = .LINEAR,
		mag_filter = .LINEAR,
		wrap_u     = .CLAMP_TO_EDGE,
		wrap_v     = .CLAMP_TO_EDGE,
	}
	state.sprite_render_pass.sampler = sg.make_sampler(sampler_desc)

	stride := (size_of(lu.Vertex))
	shader := sg.make_shader(generic_shader_desc(sg.query_backend()))
	pipeline_desc := sg.query_pipeline_defaults(
		{
			shader = shader,
			index_type = .UINT16,
			layout = {
				buffers = {0 = {stride = i32(stride)}},
				attrs = {
					ATTR_generic_in_pos = {format = .FLOAT3},
					ATTR_generic_in_col = {format = .FLOAT4, offset = size_of(lu.Vec3)},
					ATTR_generic_in_uv = {
						format = .FLOAT2,
						offset = size_of(lu.Vec3) + size_of(lu.Vec4),
					},
				},
			},
		},
	)
	state.sprite_render_pass.pip = sg.make_pipeline(pipeline_desc)
}

on_init :: proc() {
	create_sprite("assets/images/ferris.png")
}

on_frame :: proc() {
	vertices := []lu.Vertex {
		// Quad 1
		{pos = {0.5, 0.5, 0.0}, col = {1.0, 1.0, 1.0, 1.0}, uv = {0.0, 0.0}},
		{pos = {0.5, -0.5, 0.0}, col = {1.0, 1.0, 1.0, 1.0}, uv = {0.0, 1.0}},
		{pos = {-0.5, -0.5, 0.0}, col = {1.0, 1.0, 1.0, 1.0}, uv = {1.0, 1.0}},
		{pos = {-0.5, 0.5, 0.0}, col = {1.0, 1.0, 1.0, 1.0}, uv = {1.0, 0.0}},

		// {pos = {1.5, 1.5, 0.0}, col = {1.0, 1.0, 1.0, 1.0}, uv = {0.0, 0.0}},
		// {pos = {1.5, 1.5, 0.0}, col = {1.0, 1.0, 1.0, 1.0}, uv = {0.0, 1.0}},
		// {pos = {0.5, 1.5, 0.0}, col = {1.0, 1.0, 1.0, 1.0}, uv = {1.0, 1.0}},
		// {pos = {0.5, 1.5, 0.0}, col = {1.0, 1.0, 1.0, 1.0}, uv = {1.0, 0.0}},
	}

	indices: [1 * 6]u16
	quad_counter := len(vertices) / 4

	offset := 0
	for obj_count in 0 ..< quad_counter {
		i_offset := obj_count * 6
		indices[0 + i_offset] = 0 + u16(offset)
		indices[1 + i_offset] = 1 + u16(offset)
		indices[2 + i_offset] = 2 + u16(offset)
		indices[3 + i_offset] = 2 + u16(offset)
		indices[4 + i_offset] = 3 + u16(offset)
		indices[5 + i_offset] = 0 + u16(offset)

		offset += 4
	}

	// Create the vertex and index buffers for this sprite
	state.sprite_render_pass.vbuf = sg.make_buffer({data = lu.sg_range(vertices)})
	state.sprite_render_pass.ibuf = sg.make_buffer({data = lu.sg_range(indices[:])})

	// Pass Action
	pass_action := sg.Pass_Action {
		colors = {0 = {load_action = sg.Load_Action.CLEAR, clear_value = WINDOW_BG_COL}},
	}

	// Set BG Col
	sg.begin_pass(sg.Pass{action = pass_action, swapchain = shelpers.glue_swapchain()})

	// Apply 
	sg.apply_pipeline(state.sprite_render_pass.pip)
	bindings := sg.Bindings {
		vertex_buffers = {0 = state.sprite_render_pass.vbuf},
		index_buffer = state.sprite_render_pass.ibuf,
		views = {VIEW_sprite_texture = state.sprite_render_pass.view},
		samplers = {0 = state.sprite_render_pass.sampler},
	}
	sg.apply_bindings(bindings)

	// sg.apply_uniforms(UB_vs_params, sg_range(&Vs_Params{mvp = mvp_mat4}))
	sg.draw(0, len(indices) + 1, 1)

	sg.end_pass()
	sg.commit()
}

on_event :: proc() {}

on_shutdown :: proc() {
	free(p_state)
	log.debug("Goodnight.")
}

