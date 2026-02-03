class_name LevelInitializer
extends Node

@export var player_scene: PackedScene
@export var swarm_system: SwarmSystem

# New: selected playable character
@export var selected_character: PlayableCharacter

func _ready() -> void:
	if not player_scene:
		push_error("Player scene not assigned in LevelInitializer.")
		return
	if not selected_character:
		push_error("Selected character not assigned in LevelInitializer.")
		return

	# Instantiate player
	var player_instance = player_scene.instantiate()
	get_tree().get_current_scene().add_child.call_deferred(player_instance)
	player_instance.global_position = Vector3(0, 5, 0)

	# Initialize health/energy/damage
	var health_node = player_instance.get_node("Health")
	var damage_node = player_instance.get_node("Damage")
	var energy_node = player_instance.get_node("Energy")
	
	if health_node:
		health_node.current_hp = selected_character.health
	if damage_node:
		damage_node.damage = selected_character.damage
	if energy_node:
		energy_node.energy = selected_character.energy
	

	# Initialize abilities
	if player_instance.has_node("Abilities"):
		var abilities_component = player_instance.get_node("Abilities") as Abilities
		for ability_data in selected_character.abilities:
			# Duplicate the resource to avoid shared cooldowns between entities
			abilities_component.add_ability(ability_data.duplicate(), 1)

	# Assign player to swarm system
	swarm_system.player = player_instance

	print("Player initialized: ", selected_character.name)
