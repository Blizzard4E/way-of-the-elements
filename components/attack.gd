class_name Attack
extends Node

@export var attack_range: float = 1.5
@export var cooldown: float = 1.0

var _cooldown_timer: float = 0.0

func _process(delta):
	if _cooldown_timer > 0:
		_cooldown_timer -= delta

func can_attack(target: Node) -> bool:
	if _cooldown_timer > 0:
		return false
	if not target:
		return false
	
	var enemy = get_parent() as Node3D
	if not enemy:
		return false
	
	if not target is Node3D:
		return false
	
	return enemy.global_transform.origin.distance_to(target.global_transform.origin) <= attack_range

func execute(target: Node):
	if not can_attack(target):
		return
	
	var enemy = get_parent() as Node3D
	if not enemy:
		return
	 
	_cooldown_timer = cooldown
	
	# Damage target if it has a Damage component
	var damage_comp = enemy.get_node_or_null("Damage")
	if not damage_comp:
		return
	
	# Apply damage if target has Health component
	var health_comp = target.get_node_or_null("Health")
	if health_comp:
		health_comp.take_damage(damage_comp.damage)
