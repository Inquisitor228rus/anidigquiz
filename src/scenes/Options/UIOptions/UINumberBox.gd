tool
extends HBoxContainer

# Emitted when the `CheckBox` state changes.
signal changed(value_changed)

# The text of the Label should be changed to identify the setting.
# Using a setter lets us change the text when the `title` variable changes.
export var title := "" setget set_title

# We store a reference to the Label node to update its text.
onready var label := $Label
#onready var loadSettings = get_node("/root/Settings")


#	$SpinBox.value = loadSettings.SettingsSecondsOfOp

# Emit the `toggled` signal when the `CheckBox` state changes.
#func _on_CheckBox_toggled(value_changed: float) -> void:
#	emit_signal("changed", value_changed)


# This function will be executed when `title` variable changes.
func set_title(value: String) -> void:
	title = value
	# Wait until the scene is ready if `label` is null.
	if not label:
		yield(self, "ready")
	# Update the label's text
	label.text = title


#func _on_SpinBox_changed(value_changed):
#	emit_signal("changed", value_changed)


func _on_SpinBox_value_changed(value_changed):
	emit_signal("changed", value_changed)
