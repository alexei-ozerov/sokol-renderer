package app

import sg "../../vendor/sokol/gfx"


Core_Context :: struct {
    p_ac: ^App_Context
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
