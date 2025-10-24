package app


create_layer_data :: proc(on_init, on_event, on_frame, on_shutdown: proc()) -> Layer_Data {
    return Layer_Data{
        on_init = on_init,
        on_event = on_event,
        on_frame = on_frame,
        on_shutdown = on_shutdown,
    }
}
