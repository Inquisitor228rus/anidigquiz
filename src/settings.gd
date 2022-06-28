extends Node

var firstStart = 0 # специальный флаг чтобы срабатывало только при запуске игры.

var Fullscreen=false
var Vsync=true
var QuizTime=15
var Full_Opening=false
var Language="ru"
var MaxFPS=0
var StartupVideo=false


const SAVE_PATH = "user://config.ini"
const ERR_PATH = "user://err.txt"

var config = ConfigFile.new()

func newLoadSettings():
	config.load(SAVE_PATH)
	Fullscreen = config.get_value("Settings", "Fullscreen")
	Vsync = config.get_value("Settings", "Vsync")
	QuizTime = config.get_value("Game", "QuizTime")
	Full_Opening = config.get_value("Game", "Full_Opening")
	Language = config.get_value("Game", "Language")
	MaxFPS = config.get_value("Engine", "MaxFPS")
	StartupVideo = config.get_value("Engine", "StartupVideo")

func startupConfg():
	var file = File.new()
	if (not file.file_exists(ProjectSettings.globalize_path("user://config.ini"))):
		return false
	else:
		if (file.file_exists(ProjectSettings.globalize_path(ERR_PATH))):
			var dir = Directory.new()
			dir.remove(SAVE_PATH)
			dir.remove(ERR_PATH)
			return false
		newLoadSettings()
		return true
	

func OldConfigErase():
	if (config.has_section_key("Settings", "Fullscreen")):
		print("fullscreen есть")
		pass
	if (config.has_section_key("Settings", "Vsync")):
		print("Vsync есть")
		pass
	if (config.has_section_key("Game", "QuizTime")):
		print("QuizTime есть")
		pass
	if (config.has_section_key("Game", "Full_Opening")):
		print("Full_Opening есть")
		pass
	if (config.has_section_key("Engine", "MaxFPS")):
		print("MaxFPS есть")
		pass
	if (config.has_section_key("Engine", "StartupVideo")):
		print("StartupVideo есть")
		pass
	else: return false
	
func save_config(section, key, variable):
	
	config.set_value(section, key, variable)
	config.save(SAVE_PATH)


func load_config(section, key):
	config.load(SAVE_PATH)
	if (config.has_section_key(section, key)):
		config.get_value(section, key)
	else: 
		config.save(ERR_PATH)
		return
	
func _find_update():
	if (firstStart > 0):
		return
	var success = ProjectSettings.load_resource_pack(OS.get_executable_path().get_base_dir().plus_file("test" + ".pck"))
	# This could fail if, for example, mod.pck cannot be found.
	firstStart += 1
	if success:
		# Now one can use the assets as if they had them in the project from the start.
		var imported_scene = load("res://main.tscn")
	else:
		printerr(success)
		print("не загружено")
