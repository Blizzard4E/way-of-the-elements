class_name VisualFlash
extends Node

@export var meshes: Array[MeshInstance3D] = []
@export var decay_speed := 8.0

var value := 0.0

func _ready(): 
	for m in meshes:
		if not m.mesh:
			continue 

		# Get material from first surface
		var mat := m.get_active_material(0)
		if mat and mat is ShaderMaterial:
			# Duplicate and assign as material_override
			m.material_override = mat.duplicate() 

	# Connect to Health signal if present
	var health := owner.get_node_or_null("Health") as Health
	if health:
		health.damaged.connect(_on_damaged) 


func _on_damaged(amount: float):
	value = 1.0 


func _process(delta):
	if value <= 0.0:
		return

	# Decay flash
	value = max(value - delta * decay_speed, 0.0)

	# Update shader parameter on all meshes
	for m in meshes:
		if not m.mesh:
			continue
		var mat := m.material_override
		if mat and mat is ShaderMaterial:
			mat.set_shader_parameter("damage_flash", value) 
