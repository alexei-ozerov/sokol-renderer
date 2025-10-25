package app

import "base:runtime"

import "core:log"

import sapp "../../vendor/sokol/app"
import sg "../../vendor/sokol/gfx"
import sglue "../../vendor/sokol/glue"
import shelpers "../../vendor/sokol/helpers"
import slog "../../vendor/sokol/log"


// Application State Pointers
p_runtime_context: ^runtime.Context
p_app_context: ^App_Context

init_cb :: proc "c" () {
	context = p_runtime_context^

	sg.setup(
		{
			environment = sglue.environment(),
			logger = sg.Logger(shelpers.logger(p_runtime_context)),
			allocator = sg.Allocator(shelpers.allocator(p_runtime_context)),
		},
	)

	if p_app_context.p_ld != nil {
		p_app_context.p_ld.on_init()
	}
}

frame_cb :: proc "c" () {
	context = p_runtime_context^

	// Pass Action
	pass_action := sg.Pass_Action {
		colors = {0 = {load_action = sg.Load_Action.CLEAR, clear_value = p_app_context.bg_col}},
	}

	// Set BG Col
	sg.begin_pass(sg.Pass{action = pass_action, swapchain = shelpers.glue_swapchain()})
	sg.end_pass()
	sg.commit()

	if p_app_context.p_ld != nil {
		p_app_context.p_ld.on_frame()
	}
}

cleanup_cb :: proc "c" () {
	context = p_runtime_context^

	if p_app_context.p_ld != nil {
		p_app_context.p_ld.on_shutdown()
	}

	// Free resources
	sg.shutdown()
}

event_cb :: proc "c" (ev: ^sapp.Event) {
	context = p_runtime_context^

	if p_app_context.p_ld != nil {
		p_app_context.p_ld.on_event()
	}
}

