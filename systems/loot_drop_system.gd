class_name LootDropSystem
extends Node

@export var enemy_group_name: String = "Enemy"
@export var player_group_name: String = "Player"
# Reference to the DeathSystem node
@export var death_system: Node
# Array of loot scenes (PackedScene) to drop
@export var loot_table: Array[PackedScene] = []
# Array of drop chances (0.0-1.0) for each loot
@export var drop_chances: Array[float] = []

func _ready() -> void:
	if death_system:
		death_system.connect("enemy_died", Callable(self, "_on_enemy_died"))

# Called when an enemy dies
func _on_enemy_died(enemy: Node) -> void:
	# Drop loot at enemy's position
	for i in loot_table.size():
		if i < drop_chances.size() and randf() < drop_chances[i]:
			var loot_instance = loot_table[i].instantiate()
			if loot_instance and enemy.has_method("get_global_position"):
				loot_instance.global_position = enemy.global_position
			elif loot_instance and enemy.has_method("get_position"):
				loot_instance.position = enemy.position
			enemy.get_parent().add_child(loot_instance)
	