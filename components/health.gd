class_name Health
extends Node

signal health_hit_zero
signal health_changed(old_value: int, new_value: int)
signal damaged(amount: int)

var max_hp: int = 100
var current_hp: int = 100:
	set(value):
		var old = current_hp
		current_hp = clamp(value, 0, max_hp)
		health_changed.emit(old, current_hp)
		
		if current_hp == 0 and old > 0:
			health_hit_zero.emit()

func take_damage(amount: int):
	current_hp -= amount
	damaged.emit(amount)

func heal(amount: int):
	current_hp += amount
