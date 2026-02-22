extends PickupEffect
class_name HealthPickupEffect

@export var amount := 25

func activate(collector: Node) -> void:
	var health = collector.get_node_or_null("Health")
	if health:
		health.heal(amount)