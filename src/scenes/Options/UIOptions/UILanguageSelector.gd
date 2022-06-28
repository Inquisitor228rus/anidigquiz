# Scene with an OptionButton to select the resolution from a list of options
extends Control

signal language_changed(index)

# We store a reference to the OptionButton to get the selected option later




func _on_OptionButton_item_selected(index):
	emit_signal("language_changed", index)
	
