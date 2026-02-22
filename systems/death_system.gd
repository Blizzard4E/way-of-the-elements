class_name DeathSystem
extends Node

# Signal emitted when an enemy dies
signal enemy_died(enemy: Node)

@export var enemy_group_name: String = "Enemy"
@export var player_group_name: String = "Player"

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group(player_group_name)
	if not players:
		return
	var player = players[0]  # single-player for now
	var player_health = player.get_node_or_null("Health") as Health
	if player_health and player_health.current_hp <= 0:
		print("Player has died!") 
		# restart level or show game over screen here
		player.queue_free()  # Remove player from the scene
	
	for enemy in get_tree().get_nodes_in_group(enemy_group_name):
		var enemy_health = enemy.get_node_or_null("Health") as Health
		if enemy_health and enemy_health.current_hp <= 0:
			print(enemy.name, "has died!")
			emit_signal("enemy_died", enemy)
			enemy.queue_free()  # Remove enemy from the scene
	
