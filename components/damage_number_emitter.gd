extends Node
class_name DamageNumberEmitter

@export var damage_number_scene: PackedScene
@export var ui_layer_path: NodePath
 
var _ui_layer: Node = null

func _ready():
	var health = get_parent().get_node("Health") as Health
	if health:
		health.damaged.connect(_on_damaged)
	var root_ui := get_tree().get_current_scene().get_node("UI")
	if root_ui:
		_ui_layer = root_ui.get_node("DamageNumbers")

func _on_damaged(amount: float):
	if not damage_number_scene:
		return
	var cam := get_viewport().get_camera_3d()
	if cam == null:
		return

	var world_pos := get_parent().global_position as Vector3
	var screen_pos := cam.unproject_position(world_pos)

	var inst = damage_number_scene.instantiate()
	inst.position = screen_pos
	inst.set_amount(amount)

	_ui_layer.add_child(inst)
