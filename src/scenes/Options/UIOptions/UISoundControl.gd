# Scene with an OptionButton to select the resolution from a list of options
extends Control

signal sound_changed(index)

# We store a reference to the OptionButton to get the selected option later

#func _ready():
	#print(AudioServer.get_bus_volume_db(1))

export var title := "" setget set_title
export(String) var bus_name

# We store a reference to the Label node to update its text.
onready var label := $Label


# This function will be executed when `title` variable changes.
func set_title(value: String) -> void:
	title = value
	# Wait until the scene is ready if `label` is null.
	if not label:
		yield(self, "ready")
	# Update the label's text
	label.text = title


func _on_HSlider_value_changed(value):
	#$HBoxContainer/value.text = "%d%%" % (db2linear(value) * 100)
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if value > $HBoxContainer/HSlider.min_value:
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, value)
	else: 
		AudioServer.set_bus_mute(bus_idx, true)
		#$HBoxContainer/value.text = "0%"
	emit_signal("sound_changed", value)
