package main 

import "core:log"

import la "../library/app"


on_event :: proc() {
    log.debug("Trans rights.")
}

on_frame :: proc() {
    log.debug("Every frame.")
}

on_init :: proc() {
    log.debug("In the beginning.")
}

on_shutdown :: proc() {
    log.debug("Goodnight.")
}

