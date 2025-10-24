package main 

import "core:log"

import sg "../vendor/sokol/gfx"
import shelpers "../vendor/sokol/helpers"

import la "../library/app"
import lu "../library/util"


on_event :: proc() {
    log.debug("Trans rights.")
}

on_frame :: proc() {
    shader := sg.make_shader(generic_shader_desc(sg.query_backend()))
	pipeline_desc := sg.query_pipeline_defaults(
		{
			shader = shader,
			index_type = .UINT16,
			layout = {
				buffers = {0 = {stride = size_of(lu.Vertex)}},
				attrs = {
					ATTR_generic_pos = {format = .FLOAT3},
					ATTR_generic_color0 = {format = .FLOAT4, offset = size_of(lu.Vec3)},
					ATTR_generic_texcoord0 = {
						format = .FLOAT2,
						offset = size_of(lu.Vec3) + size_of(lu.Vec4),
					},
				},
			},
		},
	)
	pipeline := sg.make_pipeline(pipeline_desc)

    vertexes := []lu.Vertex{
        {pos = {-0.5, 0.0, 0.0}, col = {1.0, 0.0, 0.0, 1.0}, uv = {0.0, 0.0}},
        {pos = {-0.5, 0.0, 0.0}, col = {1.0, 0.0, 0.0, 1.0}, uv = {0.0, 0.0}},
        {pos = {-0.5, 0.0, 0.0}, col = {1.0, 0.0, 0.0, 1.0}, uv = {0.0, 0.0}},
    }
    indices := [3]int{0,1,2}

	sg.begin_pass({swapchain = shelpers.glue_swapchain()})
    sg.apply_pipeline(pipeline)

		// bindings := sg.Bindings {
			// vertex_buffers = {0 = vertexes},
			// index_buffer = indices,
			// views = {0 = nil},
			// samplers = {0 = ctx.gs.entity_buffer[sprite.entity_handle.index].sampler},
		// }
		// sg.apply_bindings(bindings)
		// sg.apply_uniforms(UB_vs_params, sg_range(&Vs_Params{mvp = mvp_mat4}))
    // sg.draw(0, 3, 1)
	sg.end_pass()
	sg.commit()
}

on_init :: proc() {
    log.debug("In the beginning.")
}

on_shutdown :: proc() {
    log.debug("Goodnight.")
}

