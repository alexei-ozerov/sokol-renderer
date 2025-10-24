package app

import "base:runtime"

import sapp "../../vendor/sokol/app"
import shelpers "../../vendor/sokol/helpers"


run_app :: proc(
	window_width: i32,
	window_height: i32,
	window_title: cstring,
	ctx: ^runtime.Context,
    cfg: ^App_Context,
) {
    // TODO (ozerova): Check on alternative ways to capture globals and 
    //                 make them available inside of the library.
    set_runtime_pointer(ctx)
    set_app_ctx_pointer(cfg)

    // Create window, bind callbacks
	sapp.run(
		{
			width = window_width,
			height = window_height,
			window_title = window_title,
			allocator = sapp.Allocator(shelpers.allocator(ctx)),
			logger = sapp.Logger(shelpers.logger(ctx)),
			init_cb = init_cb,
			frame_cb = frame_cb,
			cleanup_cb = cleanup_cb,
			event_cb = event_cb,
			icon = {sokol_default = true},
		},
	)
}
