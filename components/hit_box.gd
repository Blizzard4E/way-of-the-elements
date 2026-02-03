class_name Hitbox
extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(body: Node) -> void:
	print("Hitbox detected body: %s" % body.name)
