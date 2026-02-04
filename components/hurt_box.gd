class_name HurtBox
extends Area3D

 
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

# Hitbox calls this
func receive_damage(amount: float, source: Node) -> void:
	var owner_health = owner.get_node_or_null("Health") as Health
	if owner_health:
		owner_health.take_damage(amount)

func _on_body_entered(body: Node) -> void:
	# Optional: if you want HurtBox to auto-register damage from Hitboxes
	# This is not strictly necessary if Hitbox calls receive_damage
	pass
