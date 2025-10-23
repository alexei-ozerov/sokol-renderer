package app 

import "base:runtime"

import "core:log"

import sapp "../../vendor/sokol/app"
import sg "../../vendor/sokol/gfx"
import sglue "../../vendor/sokol/glue"
import shelpers "../../vendor/sokol/helpers"
import slog "../../vendor/sokol/log"


p_runtime_context: ^runtime.Context


init_cb :: proc "c" () {
    context = p_runtime_context^

	sg.setup(
		{
			environment = sglue.environment(),
			logger = sg.Logger(shelpers.logger(p_runtime_context)),
			allocator = sg.Allocator(shelpers.allocator(p_runtime_context)),
		},
	)
}

frame_cb :: proc "c" () {
    context = p_runtime_context^
}

cleanup_cb :: proc "c" () {
    context = p_runtime_context^

	// Free resources
	sg.shutdown()
}

event_cb :: proc "c" (ev: ^sapp.Event) {
    context = p_runtime_context^

    log.debug("Test123")
}

