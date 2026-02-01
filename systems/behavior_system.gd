class_name BehaviorSystemRunner
extends Node

@export var enemy_group_name: String = "Enemy"
@export var player_group_name: String = "Player"

func _physics_process(delta):
	var players = get_tree().get_nodes_in_group(player_group_name)
	if not players:
		return
	var player = players[0]  # single-player for now
	
	for enemy in get_tree().get_nodes_in_group(enemy_group_name):
		var attack = enemy.get_node_or_null("Attack")
		var chase = enemy.get_node_or_null("ChaseTarget")
		
		# Run behaviors independently; Attack no longer stops movement
		if attack and attack.can_attack(player):
			attack.execute(player)
		
		if chase:
			chase.execute(player, delta)
