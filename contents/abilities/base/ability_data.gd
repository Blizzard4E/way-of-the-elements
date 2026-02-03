class_name AbilityData
extends Resource

@export var name: String = "BaseAbility"
@export var base_cooldown: float = 1.0
@export var base_damage: int = 10

func tick(slot: AbilitySlot, delta: float, owner: Node) -> void:
	slot.cooldown_timer -= delta
	if slot.cooldown_timer <= 0:
		activate(slot, owner)
		slot.cooldown_timer = base_cooldown / slot.level


func activate(slot: AbilitySlot, owner: Node) -> void:
	# Default behavior (can override in subclasses)
	print("Activating", name, "Level:", slot.level)
