extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var queue
var MultiThreadVar = Settings.MultiThread

# Called when the node enters the scene tree for the first time.
func _ready():
	queue = preload("res://src/resource_queue.gd").new()
	$ColorRect/VBoxContainer/StartButton.grab_focus()
	var checkSettings = Settings.startupConfg()
	if checkSettings:
		if (Settings.firstStart > 0):
			pass
		var SAVE_PATH = "user://config.ini"
		var config = ConfigFile.new()
		config.load(SAVE_PATH)
		OS.window_fullscreen = Settings.Fullscreen
		TranslationServer.set_locale(Settings.Language)
		MultiThreadVar = Settings.MultiThread
		OS.vsync_enabled = Settings.Vsync
		AudioServer.set_bus_volume_db(1, Settings.volume_bg)
		AudioServer.set_bus_volume_db(2, Settings.volume_video)
		
#	get_node("/root/Settings").startupConfg()
	queue.start()
	get_node("ProgressBar").visible = false
	get_node("ColorRect/VBoxContainer").visible = true


	
func _on_StartButton_pressed():
	UiSound.play()
	#print("is MultiThread is: " + str(MultiThreadVar))
	if MultiThreadVar:
		$ColorRect/VBoxContainer/StartButton.disabled = true
		MultiPreload.load_scene("res://src/scenes/Game/main.tscn")
		$ColorRect/VBoxContainer/StartButton.disabled = false
	else:
		get_node("ProgressBar").visible = true
		get_node("ColorRect/VBoxContainer").visible = false
		set_process(true)
		queue.queue_resource("res://src/scenes/Game/main.tscn")
	
	#get_tree().change_scene("res://src/scenes/Game/main.tscn")
#	var success = ProjectSettings.load_resource_pack("res://videos.pck", false)
# здесь происходит проверка на наличие пакета с видосами и скриптами. в случае успеха - загружается из него видосы.
#	if success: 
#		var imported_scene = load("res://src/scenes/Game/main.tscn")
#		get_tree().change_scene("res://src/scenes/Game/main.tscn")
#	else: # иначе грузится как обычно. еще не известно как это поведет себя на мобильных устройствах.
#		get_tree().change_scene("res://src/scenes/Game/main.tscn")


func _on_OptionsButton_pressed():
	UiSound.play()
	var options = load("res://src/scenes/Options/Options.tscn").instance()
	get_tree().current_scene.add_child(options)

func _on_HelpButton_pressed():
	UiSound.play()
	pass # Replace with function body.

func _on_QuitButton_pressed():
	UiSound.play()
	queue_free()
	get_tree().quit()

func _process(_delta):
	# Returns true if a resource is done loading and ready to be retrieved.
	if queue.is_ready("res://src/scenes/Game/main.tscn"):
		set_process(false)
		# Returns the fully loaded resource.
		var next_scene = queue.get_resource("res://src/scenes/Game/main.tscn").instance()
		get_node("/root").add_child(next_scene)
		get_node("/root").remove_child(self)
		queue_free()
	else:
		# Get the progress of a resource.
		var progress = round(queue.get_progress("res://src/scenes/Game/main.tscn") * 100)
		get_node("ProgressBar").set_value(progress)
	if Settings.show_fps:
		$ColorRect/FPS_COUNT.text = str("FPS: " + String(Engine.get_frames_per_second()))

func _on_BackgroundMusic_finished():
	#$BackgroundMusic.play()
	pass


func _on_AudioStreamPlayer_finished():
	$BackgroundMusic.play()



