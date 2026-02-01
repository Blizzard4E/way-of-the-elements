class_name SwarmSystem
extends Node  # Node, not Node3D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 15.0
@export var spawn_interval: float = 1.5
@export var max_enemies: int = 100
@export var swarm_level: int = 1
@export var base_speed: float = 2.5
@export var speed_per_level: float = 0.1

@export var raycast_height: float = 10.0
@export var raycast_depth: float = 50.0
@export var floor_layer: int = 1
@export var ground_offset: float = 0.05

@export var debug_print: bool = true

var _spawn_timer: float = 0.0
var _player: Node3D = null

func _ready():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() == 0:
		push_error("No player found for SwarmSystem")
		return
	_player = players[0] as Node3D

func _physics_process(delta):
	if not _player:
		return

	_spawn_timer += delta
	if _spawn_timer >= spawn_interval:
		_spawn_timer = 0.0
		_spawn_enemy()

func _spawn_enemy():
	# Limit total enemies
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.size() >= max_enemies:
		if debug_print:
			print("[SwarmSystem] Max enemies reached: %d" % enemies.size())
		return
	if not _player:
		return

	# Instantiate enemy
	var enemy_instance = enemy_scene.instantiate() as Node3D
	get_tree().current_scene.add_child(enemy_instance)

	# Random spawn around player X/Z
	var angle = randf() * TAU
	var distance = spawn_radius * (0.5 + randf() * 0.5)
	var spawn_x = _player.global_position.x + sin(angle) * distance
	var spawn_z = _player.global_position.z + cos(angle) * distance 

	# Raycast downward to place on floor
	var ray_origin = Vector3(spawn_x, raycast_height, spawn_z)
	var ray_target = Vector3(spawn_x, -raycast_depth, spawn_z)
	var space_state = get_viewport().get_world_3d().direct_space_state

	var query = PhysicsRayQueryParameters3D.new()
	query.from = ray_origin
	query.to = ray_target
	query.collision_mask = floor_layer
	query.exclude = []

	var result = space_state.intersect_ray(query)

	var spawn_pos = Vector3(spawn_x, 0, spawn_z)
	if result:
		spawn_pos.y = result.position.y + ground_offset 

	# After the raycast result block, before setting global_position:

	# Get the ground node offset relative to the enemy root
	var ground_node = enemy_instance.get_node_or_null("Ground")
	var ground_offset_y: float = 0.0
	if ground_node:
		# The ground node's position in the enemy's local space
		# tells us how far below (or above) the root the feet are
		ground_offset_y = ground_node.position.y
		if debug_print:
			print("[SwarmSystem] Ground node local Y: ", ground_offset_y)

	# Subtract it so the feet land on the floor, not the pivot
	enemy_instance.global_position = Vector3(
		spawn_pos.x,
		spawn_pos.y - ground_offset_y,
		spawn_pos.z
	) 

	# Apply movement speed if present
	var move_comp = enemy_instance.get_node_or_null("MovementSpeed")
	if move_comp:
		move_comp.speed = base_speed + swarm_level * speed_per_level
 
