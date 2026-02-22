class_name Pickupable
extends Area3D

@export var destroy_on_activate := true
@export var effects: Array[PickupEffect] 


func _ready():
	body_entered.connect(_on_body_entered)

func _activate(collector: Node):
	for e in effects:
		e.activate(collector)
	get_parent().queue_free()

func _on_body_entered(body): 
	if body.has_node("PickupCollector"):
		_activate(body)