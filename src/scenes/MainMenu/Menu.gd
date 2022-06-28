extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var server_connection := $ServerConnection
onready var debug_panel := $DebugPanel


# Called when the node enters the scene tree for the first time.
func _ready():
	Settings._find_update()
	yield(request_authentication(), "completed")
	yield(connect_to_server(), "completed")
	yield(join_world(), "completed")
	$ColorRect/VBoxContainer/StartButton.grab_focus()
	var checkSettings = get_node("/root/Settings").startupConfg()
	if checkSettings:
		if (Settings.firstStart > 0):
			return
		var SAVE_PATH = "user://config.ini"
		var config = ConfigFile.new()
		config.load(SAVE_PATH)
		var Fullscreen
		Fullscreen = config.get_value("Settings", "Fullscreen")
		OS.window_fullscreen = Fullscreen
		var Language = config.get_value("Game", "Language")
		TranslationServer.set_locale(Language)
#	get_node("/root/Settings").startupConfg()


	# ФУНКЦИЯ АВТОРИЗАЦИИ
func request_authentication() -> void:
	var email := "test@test.com"
	var password := "password"
	debug_panel.write_message("Auth user %s." % email)
	var result: int = yield(server_connection.authenticate_async(email, password), "completed")
	#print_debug()
	if result == OK:
		debug_panel.write_message("Auth user %s success." % email)
	else:
		debug_panel.write_message("Auth user %s is not successful." % email)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func connect_to_server() -> void:
	var result: int = yield(server_connection.connect_to_server_async(), "completed")
	if result == OK:
		debug_panel.write_message("Connected to the server.")
	elif ERR_CANT_CONNECT:
		debug_panel.write_message("Could not connect")

func join_world() -> void:
	var presences: Dictionary = yield(server_connection.join_world_async(), "completed")
	debug_panel.write_message("Joined world.")
	debug_panel.write_message("Other connected players: %s" % presences.size())

func _on_StartButton_pressed():
	get_tree().change_scene("res://src/scenes/Game/main.tscn")
#	var success = ProjectSettings.load_resource_pack("res://videos.pck", false)
# здесь происходит проверка на наличие пакета с видосами и скриптами. в случае успеха - загружается из него видосы.
#	if success: 
#		var imported_scene = load("res://src/scenes/Game/main.tscn")
#		get_tree().change_scene("res://src/scenes/Game/main.tscn")
#	else: # иначе грузится как обычно. еще не известно как это поведет себя на мобильных устройствах.
#		get_tree().change_scene("res://src/scenes/Game/main.tscn")


func _on_OptionsButton_pressed():
	var options = load("res://src/scenes/Options/Options.tscn").instance()
	get_tree().current_scene.add_child(options)


func _on_QuitButton_pressed():
	queue_free()
	get_tree().quit()
