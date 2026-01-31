# player_controller.gd
class_name PlayerController
extends Node

@export var move_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var acceleration: float = 10.0
@export var friction: float = 15.0

var _velocity: Vector3 = Vector3.ZERO
var _character_body: CharacterBody3D

func _ready():
	_character_body = get_parent() as CharacterBody3D
	if not _character_body:
		push_error("PlayerController must be a child of CharacterBody3D")
		return

func _physics_process(delta):
	if not _character_body:
		return
	
	# Get input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Calculate movement direction relative to where player is facing
	var direction = (_character_body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply gravity
	if not _character_body.is_on_floor():
		_velocity.y -= 9.8 * delta
	else:
		_velocity.y = 0
	
	# Determine speed (sprint or normal)
	var current_speed = sprint_speed if Input.is_action_pressed("sprint") else move_speed
	
	# Accelerate or decelerate
	if direction:
		_velocity.x = move_toward(_velocity.x, direction.x * current_speed, acceleration * delta)
		_velocity.z = move_toward(_velocity.z, direction.z * current_speed, acceleration * delta)
	else:
		_velocity.x = move_toward(_velocity.x, 0, friction * delta)
		_velocity.z = move_toward(_velocity.z, 0, friction * delta)
	
	# Apply movement
	_character_body.velocity = _velocity
	_character_body.move_and_slide()
	
	# Update internal velocity
	_velocity = _character_body.velocity