class_name AbilityData
extends Resource

@export var name: String = "BaseAbility"
@export var cooldown: float = 1.0

func tick(slot: AbilitySlot, delta: float, owner: Node) -> void:
	slot.cooldown_timer -= delta
	if slot.cooldown_timer <= 0:
		activate(slot, owner)


func activate(slot: AbilitySlot, owner: Node) -> void:
	# Default behavior (can override in subclasses)
	print("Activating", name, "Level:", slot.level)
