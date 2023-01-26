# Controls and updates the actual game settings this node receives from the
# user interface.
extends Node2D
const SAVE_PATH = "user://config.ini"
#onready var loadSettings = get_node("/root/Settings")
# We use a dictionary to represent settings because we have few values for now. Also, when you
# have many more settings, you can replace it with an object without having to refactor the code
# too much, as in GDScript, you can access a dictionary's keys like you would access an object's
# member variables.
func update_settings(settings: Dictionary) -> void:
	OS.window_fullscreen = settings.fullscreen
#	get_tree().set_screen_stretch(
#		SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, settings.resolution
#	)
#	OS.set_window_size(settings.resolution)
	OS.vsync_enabled = settings.vsync
	Settings.save_config("Settings", "Fullscreen", settings.fullscreen)
	Settings.save_config("Settings", "Vsync", settings.vsync)
#	get_node("/root/Settings").save_config("Resolution", "Height", settings.resolution[0])
#	get_node("/root/Settings").save_config("Resolution", "Width", settings.resolution[1])
	Settings.save_config("Game", "QuizTime", settings.QuizTime)
	Settings.save_config("Game", "Full_Opening", false)
	Settings.save_config("Engine", "MaxFPS", settings.max_fps)
	Settings.save_config("Engine", "StartupVideo", false)
	Settings.save_config("Engine", "MultiThread", settings.MultiThread)
	get_node("/root/Settings").save_config("Game", "Language", settings.lang)
	
	Settings.save_config("Engine", "ShowFPS", settings.ShowFPS)
	Settings.save_config("Engine", "MusicVol", settings.VolumeBG)
	Settings.save_config("Engine", "VideoVol", settings.VolumeVideo)
	
	#loadSettings.SettingsSecondsOfOp = settings.SettingsSecondsOfOp
	#print(loadSettings.SettingsSecondsOfOp)

#func save_config(section, key, variable):
#	var config = ConfigFile.new()
#	config.set_value(section, key, variable)
#	config.save(SAVE_PATH)

# Call the `update_settings` function when the user presses the button
func _on_UIVideoSettings_apply_button_pressed(settings) -> void:
	update_settings(settings)
	
