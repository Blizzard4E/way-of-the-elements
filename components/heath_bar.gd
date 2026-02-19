class_name HeathBar
extends Sprite3D

var health_comp: Health

@export var progress_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_comp = get_parent().get_node("Health") as Health
	if health_comp:
		health_comp.damaged.connect(_on_health_changed)
		progress_bar.max_value = 100.0
		progress_bar.min_value = 0.0
		progress_bar.value = (health_comp.current_hp / health_comp.max_hp) * 100.0
		health_comp.health_changed.connect(_on_health_changed)

func _on_health_changed(amount: float) -> void:
	if health_comp.max_hp > 0:
		var health_percent = health_comp.current_hp / health_comp.max_hp
		self.scale.x = health_percent
		progress_bar.value = health_percent * 100.0
