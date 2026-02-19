extends CanvasLayer

@export var resume_button: Button
@export var pause_handler: PauseHandler

@export var exit_button: Button

@export var tab_buttons: Array[Button]
@export var tab_contents: Array[Control] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume_button.pressed.connect(_unpause)
	exit_button.pressed.connect(_exit_game)

	for i in range(tab_buttons.size()):
		tab_buttons[i].pressed.connect(func() -> void:
			_toggle_tab(i)
		)
		tab_contents[i].visible = (i == 0)
		tab_contents[i].set_process_input(i == 0)

func _toggle_tab(index: int) -> void:
	for i in range(tab_buttons.size()): 
		tab_contents[i].visible = (i == index)
		tab_contents[i].set_process_input(i == index)

func _unpause() -> void:
	pause_handler.unpause()

func _exit_game() -> void:
	get_tree().quit()
