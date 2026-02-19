extends VBoxContainer

@export var bus_name: String 

var bus_index: int

@onready var slider: HSlider = $HSlider
@onready var label: Label = $HBoxContainer/Label
@onready var value_label: Label = $HBoxContainer/ValueLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	label.text = bus_name
	slider.min_value = 0
	slider.max_value = 1
	slider.step = 0.001

	# Load saved volume from config
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	var saved_volume = null
	if err == OK:
		saved_volume = config.get_value("audio", bus_name, null)
	if saved_volume != null:
		slider.value = float(saved_volume)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(float(saved_volume)))
	else:
		slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

	value_label.text = "%d%%" % int(slider.value * 100)
	slider.value_changed.connect(_on_HSlider_value_changed)
func _on_HSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	value_label.text = "%d%%" % int(value * 100)

	# Save volume to config
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK:
		config = ConfigFile.new() # start fresh if file doesn't exist
	config.set_value("audio", bus_name, value)
	config.save("user://settings.cfg")
