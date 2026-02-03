class_name Abilities
extends Node

var abilities: Array[AbilitySlot] = []

func tick_all(delta, owner):
	for slot in abilities:
		slot.ability_data.tick(slot, delta, owner)

func add_ability(ability_data: AbilityData, level: int = 1):
	var slot = AbilitySlot.new()
	slot.ability_data = ability_data
	slot.level = level
	abilities.append(slot)

func get_ability_by_name(name: String) -> AbilitySlot:
	for slot in abilities:
		if slot.ability_data.name == name:
			return slot
	return null
