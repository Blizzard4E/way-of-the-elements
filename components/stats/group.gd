class_name Group
extends Node

@export var group_name: String = "Default"

func _ready() -> void:
	get_parent().add_to_group(group_name)
