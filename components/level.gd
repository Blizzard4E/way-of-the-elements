class_name Level
extends Node

@export var current_level: int = 1

# Signal emitted when level changes
signal level_changed(new_level: int)

func set_level(new_level: int) -> void:
	current_level = new_level
	emit_signal("level_changed", current_level)

func get_level() -> int:
	return current_level
