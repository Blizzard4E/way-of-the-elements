class_name FollowOwner
extends Node

@export var follow_target: Node3D
@export var offset: Vector3 = Vector3.ZERO
@export var follow_rotation := false

# Cannot name it "owner" as it conflicts with built-in property
var host: Node3D

func _ready() -> void:
	host = get_parent() as Node3D
	if not host:
		push_error("FollowOwner must be a child of Node3D")

func _process(_delta: float) -> void:
	if not is_instance_valid(host):
		return

	if not is_instance_valid(follow_target):
		return

	host.global_position = follow_target.global_position + offset

	if follow_rotation:
		host.global_rotation = follow_target.global_rotation
