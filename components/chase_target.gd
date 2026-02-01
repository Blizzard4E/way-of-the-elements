class_name ChaseTarget
extends Node

@export var stop_distance: float = 0.5
@export var separation_distance: float = 0.5   # min distance to other enemies
@export var separation_strength: float = 0.05  # how strongly they push apart each frame

func execute(target: Node, delta: float = 0.0):
	if not target or not target is Node3D:
		return
	
	var enemy = get_parent() as Node3D
	if not enemy:
		return
	
	# Ignore Y for chasing
	var enemy_pos = enemy.global_transform.origin
	var target_pos = target.global_transform.origin
	target_pos.y = enemy_pos.y
	
	# Base direction toward player
	var dir = target_pos - enemy_pos
	var dist = dir.length()
	
	if dist > stop_distance:
		dir = dir.normalized()
		
		# Separation from nearby enemies
		for other in get_tree().get_nodes_in_group("Enemy"):
			if other == enemy:
				continue
			var diff = enemy_pos - other.global_position
			if diff.length() < separation_distance:
				dir += diff.normalized() * separation_strength
		
		dir = dir.normalized()
		
		# Apply movement
		var move_speed_node = enemy.get_node_or_null("MovementSpeed")
		var speed = move_speed_node.speed if move_speed_node else 2.5
		
		# Use delta passed from physics_process, fallback to get_process_delta_time if not provided
		var dt = delta if delta > 0.0 else get_process_delta_time()
		enemy.global_translate(dir * speed * dt)
	
	# Always look at player horizontally
	enemy.look_at(target_pos, Vector3.UP)
