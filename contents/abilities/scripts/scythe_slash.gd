class_name ScytheSlash
extends AbilityData

func tick(slot: AbilitySlot, delta: float, owner: Node) -> void:
	super.tick(slot, delta, owner) 

func activate(slot: AbilitySlot, owner: Node) -> void:
	print(
		"[ScytheSlash] owner:",
		owner.name,
		" level:",
		slot.level,
		" damage:",
		base_damage * slot.level
	)
