package app

import sapp "../../vendor/sokol/app"


Layer_Data :: struct {
	on_init:     proc(),
	on_event:    proc(e: ^sapp.Event),
	on_frame:    proc(),
	on_shutdown: proc(),
}

create_layer :: proc(on_init: proc(), on_event: proc(e: ^sapp.Event), on_frame: proc(), on_shutdown: proc()) -> Layer_Data {
    return Layer_Data {
        on_init, on_event, on_frame, on_shutdown
    }
}
