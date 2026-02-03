class_name Hitbox
extends Area3D

var damage: float = 0

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area3D) -> void:
	# Check if the area is a HurtBox
	if area is HurtBox:
		# Tell the HurtBox to apply damage
		area.receive_damage(damage, owner)
		print("Hitbox applied", damage, "to", area.name)
