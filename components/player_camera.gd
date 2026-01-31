# player_camera.gd
class_name PlayerCamera
extends Camera3D

@export_group("Camera Position")
@export var camera_height: float = 10.0
@export var camera_angle: float = 50.0
@export var camera_distance: float = 15.0

@export_group("Follow Settings")
@export var follow_speed: float = 20
@export var use_smooth_follow: bool = true
@export var look_ahead_distance: float = 1.0

@export_group("Rotation")
@export var rotate_with_player: bool = false
@export var mouse_sensitivity: float = 0.003
@export var allow_mouse_rotation: bool = true

@export_group("Camera Settings")
@export var camera_fov: float = 50.0

@export_group("Debug")
@export var debug_print: bool = false

var _character_body: CharacterBody3D
var _manual_rotation: float = 0.0
var _is_rotating: bool = false
var _camera_focus_point: Vector3  # The point the camera is trying to follow

func _ready():
	_character_body = get_parent() as CharacterBody3D
	if not _character_body:
		push_error("PlayerCamera must be a child of CharacterBody3D")
		return
	
	far = 1000.0
	fov = camera_fov
	make_current()
	
	# Initialize focus point
	_camera_focus_point = _character_body.global_position
	
	_update_camera_transform(true)

func _unhandled_input(event):
	if not allow_mouse_rotation:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_is_rotating = event.pressed
	
	if event is InputEventMouseMotion and _is_rotating:
		_manual_rotation += -event.relative.x * mouse_sensitivity

func _process(delta):
	_update_camera_transform(false, delta)

func _update_camera_transform(instant: bool, delta: float = 0.0):
	if not _character_body:
		return
	
	# Smoothly move the focus point toward the player
	if instant:
		_camera_focus_point = _character_body.global_position
	else:
		if use_smooth_follow:
			# THIS is where the lag happens - focus point chases player
			_camera_focus_point = _camera_focus_point.lerp(
				_character_body.global_position, 
				follow_speed * delta
			)
		else:
			_camera_focus_point = _character_body.global_position
	
	# Calculate camera position relative to focus point (not player!)
	var angle_rad = deg_to_rad(camera_angle)
	var total_rotation = _manual_rotation
	
	if rotate_with_player:
		total_rotation += _character_body.rotation.y
	
	var horizontal_distance = camera_distance * cos(angle_rad)
	
	var offset = Vector3(
		sin(total_rotation) * horizontal_distance,
		camera_height,
		cos(total_rotation) * horizontal_distance
	)
	
	# Position camera relative to the FOCUS POINT, not the player
	global_position = _camera_focus_point + offset
	
	# Look at focus point
	var player_forward = -_character_body.global_transform.basis.z
	var look_target = _camera_focus_point + player_forward * look_ahead_distance
	look_at(look_target, Vector3.UP)
	
	if debug_print and Engine.get_frames_drawn() % 60 == 0:
		print("Player Pos: ", _character_body.global_position)
		print("Focus Point: ", _camera_focus_point)
		print("Distance: ", _camera_focus_point.distance_to(_character_body.global_position))
		print("---")
