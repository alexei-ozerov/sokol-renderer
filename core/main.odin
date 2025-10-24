package main

import "base:runtime"

import "core:log"

import la "../library/app"


runtime_context: runtime.Context
state : la.Core_Context
p_state := &state

main :: proc() {
	context.logger = log.create_console_logger()
	runtime_context = context

    // Configure application
    app_context := la.App_Context{}
    app_context.bg_col = WINDOW_BG_COL

    // Setup layer
    app_context.p_ld = &la.Layer_Data{
        on_init, 
        on_event, 
        on_frame, 
        on_shutdown
    }

    // Run application
	la.run_app(
			window_width = WINDOW_WIDTH,
			window_height = WINDOW_HEIGHT,
			window_title = WINDOW_TITLE,
            ctx = &runtime_context,
            cfg = &app_context,
	)

}
