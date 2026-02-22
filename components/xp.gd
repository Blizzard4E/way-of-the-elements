class_name XP
extends Node

@export var current_xp: int = 0
@export var xp_cap: int = 100

# Signal emitted when XP changes
signal xp_changed(new_xp: int)

func add_xp(amount: int) -> void:
	current_xp += amount
	emit_signal("xp_changed", current_xp)
