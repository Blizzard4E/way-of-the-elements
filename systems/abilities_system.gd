class_name AbilitiesSystem
extends Node

@export var enemy_group_name: String = "Enemy"
@export var player_group_name: String = "Player"

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group(player_group_name)
	if not players:
		return
	var player = players[0]  # single-player for now
	var player_abilities = player.get_node("Abilities") as Abilities
	
	if player_abilities:
		player_abilities.tick_all(delta, player)
		
	for enemy in get_tree().get_nodes_in_group(enemy_group_name):
		var enemy_abilities = enemy.get_node("Abilities") as Abilities
		
		if enemy_abilities:
			enemy_abilities.tick_all(delta, enemy)
	