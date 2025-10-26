package app

import lu "../util"

import sg "../../vendor/sokol/gfx"


Render_Data :: struct {
    // Quad Pass
	image:          sg.Image,
	sampler:        sg.Sampler,
	view:           sg.View,
	bind:           sg.Bindings,

    // Restructure
    camera:         Render_Camera,
    qvb:            sg.Buffer, // Quad Vertex Buffer
    qib:            sg.Buffer, // Quad Index Buffer
    quad_pip:       sg.Pipeline,
    quad_pass:      sg.Pass,
    quad_image:     sg.Image,
}

Render_Camera :: struct {
    pos:     lu.Vec2,
    rot:     f32,
    extents: f32,
}

Render_Shape_Instance :: struct {
    pos:   lu.Vec3,
    right: lu.Vec2,
    up:    lu.Vec2,
    color: lu.Vec4,
}

Render_Sprite_Instance :: struct {
    pos:       lu.Vec3,
    right:     lu.Vec2,
    up:        lu.Vec2,
    mul_color: lu.Vec4,
    add_color: lu.Vec4,
    tex_min:   lu.Vec2,
    tex_size:  lu.Vec2,
}

Render_Shape :: enum u8 {
    Triangle,
    Rectangle,
}
