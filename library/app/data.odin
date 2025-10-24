package app

import lu "../util"

import sg "../../vendor/sokol/gfx"


Core_Context :: struct {
	p_ac:               ^App_Context,
	sprite_render_pass: Render_Data,
}

Render_Data :: struct {
	image:          sg.Image,
	texture_buffer: [dynamic]sg.Image,
	sampler:        sg.Sampler,
	view:           sg.View,
	pip:            sg.Pipeline,
	bind:           sg.Bindings,
	vbuf:           sg.Buffer,
	ibuf:           sg.Buffer,
	vdata:          []lu.Vertex,
	idata:          []u16,
}

App_Context :: struct {
	bg_col: sg.Color,
	p_ld:   ^Layer_Data,
}

Layer_Data :: struct {
	on_init:     proc(),
	on_event:    proc(),
	on_frame:    proc(),
	on_shutdown: proc(),
}

