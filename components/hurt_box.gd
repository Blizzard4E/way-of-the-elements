class_name HurtBox
extends Area3D

# Optional: link to Health or other stats on the entity
var owner_health: Node = null

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

# Hitbox calls this
func receive_damage(amount: float, source: Node) -> void:
	if owner_health:
		owner_health.apply_damage(amount, source)

func _on_body_entered(body: Node) -> void:
	# Optional: if you want HurtBox to auto-register damage from Hitboxes
	# This is not strictly necessary if Hitbox calls receive_damage
	pass
