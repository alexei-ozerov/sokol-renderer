package main

import "base:builtin"
import "base:runtime"

import "core:fmt"
import "core:log"
import "core:math"
import "core:math/linalg"
import "core:strings"
import "core:time"

import sapp "../vendor/sokol/app"
import sg "../vendor/sokol/gfx"
import sglue "../vendor/sokol/glue"
import shelpers "../vendor/sokol/helpers"
import slog "../vendor/sokol/log"

import la "../library/app"
import ld "../library/data"
import lu "../library/util/"


runtime_context: runtime.Context
state : ld.Core_Context
p_state := &state


main :: proc() {
	context.logger = log.create_console_logger()
	runtime_context = context

    app_context := ld.App_Context {
        bg_col = WINDOW_BG_COL
    }

	la.run_app(
			window_width = WINDOW_WIDTH,
			window_height = WINDOW_HEIGHT,
			window_title = WINDOW_TITLE,
            ctx = &runtime_context,
            cfg = &app_context,
	)
}
