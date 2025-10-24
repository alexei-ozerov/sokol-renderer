package app

import sg "../../vendor/sokol/gfx"


Core_Context :: struct {
    p_ac: ^App_Context,
    sprite_render_pass: Render_Data
}

Render_Data :: struct {
	texture_buffer:         [dynamic]sg.Image,
	vertex_buffer: sg.Buffer,
	index_buffer:  sg.Buffer,
	sampler:       sg.Sampler,
	view:          sg.View,
}

App_Context :: struct {
    bg_col: sg.Color,
    p_ld: ^Layer_Data,
}

Layer_Data :: struct {
    on_event: proc(),
    on_frame: proc(),
    on_init: proc(),
    on_shutdown: proc(),
}
