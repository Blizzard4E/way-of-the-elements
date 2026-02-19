class_name PauseHandler
extends Node

@export var settings_menu: CanvasLayer

var is_paused: bool = false

func _ready() -> void:
	settings_menu.hide()
  
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"): 
		_toggle_pause()

func _toggle_pause():
	if is_paused:
		unpause()
	else:
		pause()

func pause():
	settings_menu.show()
	get_tree().paused = true
	is_paused = true

func unpause():
	settings_menu.hide()
	get_tree().paused = false
	is_paused = false