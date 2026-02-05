extends Control
class_name DamageNumber2D

@export var float_speed := 60.0
@export var lifetime := 0.8

@export var label: Label 

var _time := 0.0

func set_amount(amount: float):
	label.text = str(roundi(amount))

func _process(delta):
	_time += delta
	position.y -= float_speed * delta
	modulate.a = 1.0 - (_time / lifetime)

	if _time >= lifetime:
		queue_free()
