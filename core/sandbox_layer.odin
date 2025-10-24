package main 

import "core:log"

import "vendor:stb/image"

import sg "../vendor/sokol/gfx"
import shelpers "../vendor/sokol/helpers"

import la "../library/app"
import lu "../library/util"


on_init :: proc() {
    // Load Image
    width, height, channels: i32
    pixels := image.load("/home/aozerov/projects/sokol-renderer/assets/images/ferris.png", &width, &height, &channels, 4)
    if pixels == nil {
        log.fatal("failed to load image")
    }

    img_desc := sg.Image_Desc {
        width = width,
        height = height,
        pixel_format = .RGBA8,
        data = {mip_levels = {0 = {ptr = pixels, size = uint(width * height * 4)}}},
    }
    // sg_image := sg.make_image(img_desc)
    defer image.image_free(pixels) // TODO: (ozerova): Check if this needs to be cleaned up in cleanup_cb()

    // Create the view
    // view_desc := sg.View_Desc {
    //     texture = {image = sg_image},
    // }
    // sg_view := sg.make_view(view_desc)

    // Create a sampler
    // sampler_desc := sg.Sampler_Desc {
    //     min_filter = .LINEAR,
    //     mag_filter = .LINEAR,
    //     wrap_u     = .CLAMP_TO_EDGE,
    //     wrap_v     = .CLAMP_TO_EDGE,
    // }
    // sg_sampler := sg.make_sampler(sampler_desc)

    // Create the vertex and index buffers for this sprite
    // vertex_data: []lu.Vertex
    // index_data: []i32
    // vertex_buffer := sg.make_buffer({data = lu.sg_range(vertex_data)})
    // index_buffer := sg.make_buffer({data = lu.sg_range(index_data)})
}

on_frame :: proc() {
    // shader := sg.make_shader(generic_shader_desc(sg.query_backend()))

    vertices := []lu.Vertex{
        // Quad 1
        {pos = {0.5, 0.5, 0.0}, col = {1.0, 0.0, 0.0, 1.0}, uv = {1.0, 1.0}},
        {pos = {0.5, -0.5, 0.0}, col = {0.0, 1.0, 0.0, 1.0}, uv = {1.0, 0.0}},
        {pos = {-0.5, -0.5, 0.0}, col = {0.0, 0.0, 1.0, 1.0}, uv = {0.0, 0.0}},
        {pos = {-0.5, 0.5, 0.0}, col = {1.0, 1.0, 0.0, 1.0}, uv = {0.0, 1.0}},

        // Quad 2
        {pos = {1.5, 1.5, 0.0}, col = {1.0, 0.0, 0.0, 1.0}, uv = {1.0, 1.0}},
        {pos = {1.5, 0.5, 0.0}, col = {0.0, 1.0, 0.0, 1.0}, uv = {1.0, 0.0}},
        {pos = {0.5, 0.5, 0.0}, col = {0.0, 0.0, 1.0, 1.0}, uv = {0.0, 0.0}},
        {pos = {0.5, 1.5, 0.0}, col = {1.0, 1.0, 0.0, 1.0}, uv = {0.0, 1.0}},
    }

    indices : [MAX_QUADS * 6]int
    stride := (size_of(lu.Vertex))
    quad_counter := len(vertices) / 4

    offset := 0
    for obj_count in 0..<quad_counter {
        i_offset := obj_count * 6
        indices[0 + i_offset] = 0 + offset
        indices[1 + i_offset] = 1 + offset 
        indices[2 + i_offset] = 2 + offset 
        indices[3 + i_offset] = 2 + offset 
        indices[4 + i_offset] = 3 + offset 
        indices[5 + i_offset] = 0 + offset

        offset += 4
    }

    // Render vertices
	// sg.begin_pass({swapchain = shelpers.glue_swapchain()})
	// sg.end_pass()
	// sg.commit()
}

on_event :: proc() {}

on_shutdown :: proc() {
    log.debug("Goodnight.")
}

