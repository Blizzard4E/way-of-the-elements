class_name PlayerLevelSystem
extends Node

@export var death_system: Node
@export var player_group_name: String = "Player"
@export var xp_per_enemy: int = 10
@export var level_cap_base: int = 100
@export var level_cap_growth: float = 1.5

# Signal emitted when player levels up
signal player_leveled_up(new_level: int)

func _ready() -> void:
	if death_system:
		death_system.connect("enemy_died", Callable(self, "_on_enemy_died"))

func _on_enemy_died(enemy: Node) -> void:
	# Find player and add XP
	for player in get_tree().get_nodes_in_group(player_group_name):
		var xp_component = player.get_node_or_null("XP")
		var level_component = player.get_node_or_null("Level") as Level
		if xp_component and level_component:
			xp_component.add_xp(xp_per_enemy)
			_check_level_up(level_component, xp_component)

func _check_level_up(level_component: Level, xp_component: Node) -> void:
	var player_level = level_component.current_level
	var cap = int(level_cap_base * pow(level_cap_growth, player_level - 1))
	if xp_component.current_xp >= cap:
		xp_component.current_xp -= cap
		player_level += 1
		level_component.set_level(player_level)
		emit_signal("player_leveled_up", player_level)
		# Optionally update XP cap
		xp_component.xp_cap = int(level_cap_base * pow(level_cap_growth, player_level - 1))

		# --- TEMP: Upgrade all abilities by 1 level ---
		# In the future, allow player to choose which ability to upgrade
		var player = level_component.get_owner()
		var abilities_node = player.get_node_or_null("Abilities")
		if abilities_node:
			for slot in abilities_node.abilities:
				slot.level += 2
