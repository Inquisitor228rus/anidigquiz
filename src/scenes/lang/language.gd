extends Control

const SAVE_PATH = "user://config.ini"

func _on_Button_pressed():
	#var options = load("res://src/scenes/lang/language.tscn").instance()
	print("переход")
	get_node("/root/Settings").save_config("Game", "Language", 1)
	get_tree().change_scene("res://src/scenes/MainMenu/Menu.tscn")
	#get_tree().current_scene.remove_child()
	#get_tree().change_scene("res://src/scenes/MainMenu/Menu.tscn")

var language_map = {"ENG": "en", "RUS": "ru", "PIR": "pr", "UKR": "uk"}

func _on_UILanguageSelector_language_changed(index):
	TranslationServer.set_locale(language_map[index])
	get_node("/root/Settings").save_config("Game", "Language", language_map[index])
