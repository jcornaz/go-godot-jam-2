extends Node2D

signal event_registered(event)
signal event_unregistered(event)

func register_event(event: Event):
	emit_signal("event_registered", event)

func unregister_event(event: Event):
	emit_signal("event_unregistered", event)
