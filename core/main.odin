package main

import "base:runtime"

import "core:log"

import sapp "../vendor/sokol/app"

import la "../library/app"


runtime_context: runtime.Context
state: la.Core_Context
p_state := &state

main :: proc() {
	context.logger = log.create_console_logger()
	runtime_context = context

	// Configure application
	app_context := la.App_Context {
		bg_col = WINDOW_BG_COL,
	}

	// Setup layer
    layer_2d := la.create_layer(on_init, on_event, on_frame, on_shutdown)
    layer_3d := la.create_layer(on_3d_init, on_3d_event, on_3d_frame, on_3d_shutdown)
	app_context.p_ld = &layer_3d // Switch between layers here.

    // Construct State
    state.p_ac = &app_context
    state.p_rc = &runtime_context

	// Run application
	la.run_app(
		window_width = WINDOW_WIDTH,
		window_height = WINDOW_HEIGHT,
		window_title = WINDOW_TITLE,
        ctx = &state,
	)
}

