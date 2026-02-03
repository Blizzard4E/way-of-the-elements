class_name Lifetime
extends Node

@export var duration: float = 1.0
var time_left: float
var host: Node

func _ready() -> void:
	host = get_parent()
	time_left = duration

func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0.0 and is_instance_valid(host):
		host.queue_free()
