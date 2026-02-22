class_name XPBar
extends Sprite3D

@export var xp_component: Node
@export var progress_bar: ProgressBar

func _ready() -> void:
	if xp_component:
		xp_component.connect("xp_changed", Callable(self, "_on_xp_changed"))
		_update_bar()

func _on_xp_changed(new_xp: int) -> void:
	_update_bar()

func _update_bar() -> void:
	if not xp_component or not progress_bar:
		return
	progress_bar.max_value = xp_component.xp_cap
	progress_bar.value = xp_component.current_xp
