package main


import "core:os"
import "core:log"
import "core:math/linalg"
import "core:image/png"
import "core:slice"

import "vendor:stb/image"

import sapp "../vendor/sokol/app"
import sg "../vendor/sokol/gfx"
import sglue "../vendor/sokol/glue"
import shelpers "../vendor/sokol/helpers"

import la "../library/app"
import lu "../library/util"


Vertex :: struct {
	x, y, z: f32,
	color: u32,
	u, v: u16,
}

on_3d_init :: proc() {
    vertices := [?]Vertex {
		// pos               color       uvs
		{ -1.0, -1.0, -1.0,  0xFF0000FF,     0,     0 },
		{  1.0, -1.0, -1.0,  0xFF0000FF, 32767,     0 },
		{  1.0,  1.0, -1.0,  0xFF0000FF, 32767, 32767 },
		{ -1.0,  1.0, -1.0,  0xFF0000FF,     0, 32767 },

		{ -1.0, -1.0,  1.0,  0xFF00FF00,     0,     0 },
		{  1.0, -1.0,  1.0,  0xFF00FF00, 32767,     0 },
		{  1.0,  1.0,  1.0,  0xFF00FF00, 32767, 32767 },
		{ -1.0,  1.0,  1.0,  0xFF00FF00,     0, 32767 },

		{ -1.0, -1.0, -1.0,  0xFFFF0000,     0,     0 },
		{ -1.0,  1.0, -1.0,  0xFFFF0000, 32767,     0 },
		{ -1.0,  1.0,  1.0,  0xFFFF0000, 32767, 32767 },
		{ -1.0, -1.0,  1.0,  0xFFFF0000,     0, 32767 },

		{  1.0, -1.0, -1.0,  0xFFFF007F,     0,     0 },
		{  1.0,  1.0, -1.0,  0xFFFF007F, 32767,     0 },
		{  1.0,  1.0,  1.0,  0xFFFF007F, 32767, 32767 },
		{  1.0, -1.0,  1.0,  0xFFFF007F,     0, 32767 },

		{ -1.0, -1.0, -1.0,  0xFFFF7F00,     0,     0 },
		{ -1.0, -1.0,  1.0,  0xFFFF7F00, 32767,     0 },
		{  1.0, -1.0,  1.0,  0xFFFF7F00, 32767, 32767 },
		{  1.0, -1.0, -1.0,  0xFFFF7F00,     0, 32767 },

		{ -1.0,  1.0, -1.0,  0xFF007FFF,     0,     0 },
		{ -1.0,  1.0,  1.0,  0xFF007FFF, 32767,     0 },
		{  1.0,  1.0,  1.0,  0xFF007FFF, 32767, 32767 },
		{  1.0,  1.0, -1.0,  0xFF007FFF,     0, 32767 },
	}
	state.renderer.bind.vertex_buffers[0] = sg.make_buffer({
		data = { ptr = &vertices, size = size_of(vertices) },
	})

	// create an index buffer for the cube
	indices := [?]u16 {
		0, 1, 2,  0, 2, 3,
		6, 5, 4,  7, 6, 4,
		8, 9, 10,  8, 10, 11,
		14, 13, 12,  15, 14, 12,
		16, 17, 18,  16, 18, 19,
		22, 21, 20,  23, 22, 20,
	}
	state.renderer.bind.index_buffer = sg.make_buffer({
		usage = {
			index_buffer = true,
		},
		data = { ptr = &indices, size = size_of(indices) },
	})

	if img_data, img_data_ok := read_entire_file("assets/images/round_cat.png", context.temp_allocator); img_data_ok {
		if img, img_err := png.load_from_bytes(img_data, allocator = context.temp_allocator); img_err == nil {
			sg_img := sg.make_image({
				width = i32(img.width),
				height = i32(img.height),
				data = {
					mip_levels = {
						0 = {
							ptr = raw_data(img.pixels.buf),
							size = uint(slice.size(img.pixels.buf[:])),
						},
					},
				},
			})

			state.renderer.bind.views[VIEW_tex] = sg.make_view({
				texture = sg.Texture_View_Desc({image = sg_img}),
			})
		} else {
			log.error(img_err)
		}
	} else {
		log.error("Failed loading texture")
	}

	// a sampler with default options to sample the above image as texture
	state.renderer.bind.samplers[SMP_smp] = sg.make_sampler({})

	// shader and pipeline object
	state.renderer.pip = sg.make_pipeline({
		shader = sg.make_shader(texcube_shader_desc(sg.query_backend())),
		layout = {
			attrs = {
				ATTR_texcube_pos = { format = .FLOAT3 },
				ATTR_texcube_color0 = { format = .UBYTE4N },
				ATTR_texcube_texcoord0 = { format = .SHORT2N },
			},
		},
		index_type = .UINT16,
		cull_mode = .BACK,
		depth = {
			compare = .LESS_EQUAL,
			write_enabled = true,
		},
	})
}

on_3d_frame :: proc() {
    dt := f32(sapp.frame_duration())
	state.renderer.rx += 60 * dt
	state.renderer.ry += 120 * dt

	// vertex shader uniform with model-view-projection matrix
	vs_params := Vs_Params {
		mvp = compute_mvp(state.renderer.rx, state.renderer.ry),
	}

	pass_action := sg.Pass_Action {
		colors = {
			0 = { load_action = .CLEAR, clear_value = { 0.41, 0.68, 0.83, 1 } },
		},
	}

	sg.begin_pass({ action = pass_action, swapchain = sglue.swapchain() })
	sg.apply_pipeline(state.renderer.pip)
	sg.apply_bindings(state.renderer.bind)
	sg.apply_uniforms(UB_vs_params, { ptr = &vs_params, size = size_of(vs_params) })

	// 36 is the number of indices
	sg.draw(0, 36, 1)

	sg.end_pass()
	sg.commit()

	free_all(context.temp_allocator)
}

compute_mvp :: proc (rx, ry: f32) -> lu.Mat4 {
	proj := linalg.matrix4_perspective(60.0 * linalg.RAD_PER_DEG, sapp.widthf() / sapp.heightf(), 0.01, 10.0)
	view := linalg.matrix4_look_at_f32({0.0, -1.5, -6.0}, {}, {0.0, 1.0, 0.0})
	view_proj := proj * view
	rxm := linalg.matrix4_rotate_f32(rx * linalg.RAD_PER_DEG, {1.0, 0.0, 0.0})
	rym := linalg.matrix4_rotate_f32(ry * linalg.RAD_PER_DEG, {0.0, 1.0, 0.0})
	model := rxm * rym
	return view_proj * model
}

force_reset: bool

on_3d_event :: proc(e: ^sapp.Event) {
	#partial switch e.type {
	case .KEY_DOWN:
		if e.key_code == .F6 {
			force_reset = true
		}
	}
}

on_3d_shutdown :: proc() {
	free(p_state)
	log.debug("Goodnight.")
}

read_entire_file :: proc(name: string, allocator := context.allocator, loc := #caller_location) -> (data: []byte, success: bool) {
	when IS_WEB {
		return web.read_entire_file(name, allocator, loc)
	} else {
		return os.read_entire_file(name, allocator, loc)
	}
}
