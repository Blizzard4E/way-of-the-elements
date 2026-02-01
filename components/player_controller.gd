class_name PlayerController
extends Node

@export var rotation_speed: float = 10.0  # how fast player turns
@export var gravity: float = 9.8
@export var jump_force: float = 5.0

var _character_body: CharacterBody3D
var _velocity: Vector3 = Vector3.ZERO

func _ready():
	_character_body = get_parent() as CharacterBody3D
	if not _character_body:
		push_error("PlayerController must be a child of CharacterBody3D")

func _physics_process(delta):
	if not _character_body:
		return
	
	# Input vector
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
	
	# Horizontal movement
	var move_speed_node = _character_body.get_node_or_null("MovementSpeed")
	var speed = move_speed_node.speed if move_speed_node else 5.0
	var move_vector = Vector3(input_dir.x, 0, input_dir.y) * speed
	_velocity.x = move_vector.x
	_velocity.z = move_vector.z
	
	# Gravity
	if not _character_body.is_on_floor():
		_velocity.y -= gravity * delta
	else:
		_velocity.y = 0
		# Jump
		if Input.is_action_just_pressed("jump"):
			_velocity.y = jump_force
	
	# Apply movement
	_character_body.velocity = _velocity
	_character_body.move_and_slide()
	
	# Smooth rotation toward movement direction (ignore Y)
	if move_vector.length() > 0:
		var desired_dir = move_vector.normalized()
		var current_rot = _character_body.rotation
		var target_yaw = atan2(-desired_dir.x, -desired_dir.z)
		current_rot.y = lerp_angle(current_rot.y, target_yaw, rotation_speed * delta)
		_character_body.rotation = current_rot
