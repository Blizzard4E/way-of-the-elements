class_name Health
extends Node

signal health_hit_zero
signal health_changed(old_value: float, new_value: float)
signal damaged(amount: float)

@export var max_hp: float = 100
@export var current_hp: float = 100:
	set(value):
		var old = current_hp
		current_hp = clamp(value, 0, max_hp)
		health_changed.emit(old, current_hp)
		
		if current_hp == 0 and old > 0:
			health_hit_zero.emit()

func take_damage(amount: float):
	current_hp -= amount 
	damaged.emit(amount)

func heal(amount: float):
	current_hp += amount
