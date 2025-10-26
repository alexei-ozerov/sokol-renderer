package app

import "base:runtime"

import sg "../../vendor/sokol/gfx"


Core_Context :: struct {
	p_ac:     ^App_Context,
    p_rc:     ^runtime.Context,
	renderer: Render_Data,
}

App_Context :: struct {
    bg_col: sg.Color,
    p_ld:   ^Layer_Data,
}

set_runtime_pointer :: proc(ctx: ^runtime.Context) {
	p_runtime_context = ctx
}

set_app_ctx_pointer :: proc(ctx: ^App_Context) {
	p_app_context = ctx
}

set_layer_data_pointer :: proc(ctx: ^Layer_Data) {
	p_app_context.p_ld = ctx
}

