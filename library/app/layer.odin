package app


Layer_Data :: struct {
	on_init:     proc(),
	on_event:    proc(),
	on_frame:    proc(),
	on_shutdown: proc(),
}
