extends Node

enum QuestionType { VIDEO }

export(Resource) var bd_quiz
export(Color) var color_right
export(Color) var color_wrong
export(int) var max_anime_list


var buttons := []
var index := 0
var quiz_shuffle := []
var correct := 0
var QuizTime = Settings.QuizTime
var answers := 0
#const quiz_answers := bd_quiz.quiz_answers

#var newArr := []
# timer
var timer
var seconds: int = QuizTime
var quizTimerForPlayer = QuizTime - 5
var Full_Opening
# end timer
var MultiThreadVar = Settings.MultiThread

var my_data = {"Score":0}
func update_score(new_score):
	my_data["Score"] = new_score
	print(new_score)
	if (new_score == 15):
		Settings.save_config("save_file", "user", my_data)
		#save_data(my_data, "save_file", "user")


onready var question_video := $Node/VideoPlayer
onready var question_texts := $Node/question_info/txt
	
func uniLoadConfig(section, key): # уникальная функция для вызова подобных штук. хоть их и требуется всего два но все же.
	var SAVE_PATH = "user://config.ini"
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	return config.get_value(section, key)

func _ready() -> void:
	var checkSettings = get_node("/root/Settings").startupConfg()
	if checkSettings:
		Full_Opening = uniLoadConfig("Game", "Full_Opening")
		if uniLoadConfig("Game", "QuizTime") > 25:
			QuizTime = 25
			quizTimerForPlayer = 20
		elif uniLoadConfig("Game", "QuizTime") < 15:
			QuizTime = 15
			quizTimerForPlayer = 10
		else: QuizTime = uniLoadConfig("Game", "QuizTime")
		seconds = QuizTime
		quizTimerForPlayer = QuizTime - 5
	
	for _button in $Node/question_buttons/VBoxContainer.get_children():
		buttons.append(_button)
	#quiz_shuffle = randomize_array(bd_quiz.bd)
	quiz_shuffle = bd_quiz.main()
	load_quiz()
	timer = Timer.new()
	timer.connect("timeout",self,"TimerTimeout") 
	timer.set_wait_time(1) #value is in seconds: 600 seconds = 10 minutes
	timer.set_one_shot(false)
	add_child(timer) 
	timer.start() 
	$Node/question_buttons/VBoxContainer/Button.grab_focus()
	#randomize_array_in_start()
	$Node/CountPanel/AllVideosCount.set_text(" из " + str(bd_quiz.quiz_answers))
	
func _process(_delta):
	if Settings.show_fps:
		$Node/FPS_COUNT.text = str("FPS: " + String(Engine.get_frames_per_second()))
	


func load_quiz() -> void:
	#if index >= bd_quiz.bd.size():
	if index >= bd_quiz.quiz_answers:
		game_over()
		$Node/question_info/txt.set_text(str(str("You finish game!")))
		timer.stop()
		return
	
	#question_texts.text = str(quiz_shuffle[index].question_info) отображать информацию в лейбле
	$Node/VideoPlayer/anime_name.text = str(quiz_shuffle[index].question_info)
	question_texts.text = "" # пустая строка в лейбле
	for bt in buttons:
		bt.disabled = false
	answers = answers + 1
	$Node/CountPanel/RightNowVideoCount.set_text(str(answers))
	
	#var options = randomize_array(bd_quiz.bd[index].options)
	var options = random_animeList([bd_quiz.bd[index].correct])
	#var options = bd_quiz.bd[index].options
	
	# DEBUG
	if OS.is_debug_build():
		print("сейчас играет: " + str(quiz_shuffle[index].question_info) + "\nвыбор из: " + str(options))# + "\nИндекс бд: " + str(bd_quiz.bd[index]))
	
	
	$Node/CountPanel/RightNowVideoCount.show()
	$Node/CountPanel/AllVideosCount.show()
	for i in buttons.size():
		buttons[i].text = str(options[i])
		buttons[i].connect("pressed", self, "buttons_answer", [buttons[i]])
	
	match bd_quiz.bd[index].type:
		QuestionType.VIDEO:
			#print(OS.get_name())
			#var DebugOS = true
			#if DebugOS:
			if !OS.get_name() == "Windows":
				#print("lib launched")
				var stream = VideoStreamGDNative.new()
				var file = bd_quiz.bd[index].question_video.get_file()
				stream.set_file(file)
				question_video.stream = stream
				#question_video.stream = bd_quiz.bd[index].question_video
				question_video.play()
			else:
				#print("lib DOSnt launched")
				question_video.stream = bd_quiz.bd[index].question_video
				question_video.play()
		
func buttons_answer(button) -> void:
	UiSound.play()
	if bd_quiz.bd[index].correct == button.text:
		button.modulate = color_right
		correct += 1
		update_score(correct)
		$ErrPanel.write_message(str(correct))
	else:
		button.modulate = color_wrong
	
	for bt in buttons:
		bt.disabled = true
		
	#$Node/question_info/txt.hide()
	#var timer_seconds = seconds
	seconds = QuizTime
	quizTimerForPlayer = QuizTime - 5
	$Node/question_info/txt.set_text("")
	yield(get_tree().create_timer(1), "timeout")
	$Node/CountPanel/RightNowVideoCount.hide()
	$Node/CountPanel/AllVideosCount.hide()
	$Node/VideoPlayer.show()
	timer.stop()
	yield(get_node("Node/VideoPlayer"), "finished")
	timer.start()
	$Node/question_info/txt.show()
	#yield(get_tree().create_timer(30 - $Node/VideoPlayer.get_stream_position()), "timeout")
	
	$Node/VideoPlayer.set_visible(false)
	question_video.stop()
	for bt in buttons:
		bt.modulate = Color.white
		bt.disconnect("pressed", self, "buttons_answer")
		
	question_video.stream = null
	index += 1
	load_quiz()

func random_animeList(array: Array) -> Array:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var p : int = 0 # для генерации названия аниме в randi_range
	while array.size() < 4:
		p = rng.randi_range(1, max_anime_list)
		if p >= 100:
			var o = "ANIME_" + str(p)
			if !array.has(o):
				array.append(o)
		elif p < 10:
			var o = "ANIME_" + "00" + str(p)
			if !array.has(o):
				array.append(o)
		else:
			var o = "ANIME_" + "0" + str(p)
			if !array.has(o):
				array.append(o)
	array.shuffle()
	return array

func game_over() -> void:
	$Node/game_over.show()
	$Node/returnBack.hide()
	$Node/CountPanel/RightNowVideoCount.hide()
	$Node/CountPanel/AllVideosCount.hide()
	#$Node/game_over/txt_result.text = str(correct, "/", bd_quiz.bd.size())
	$Node/game_over/txt_result.text = str(correct, "/", answers)
	$Node/game_over/buttons_restart.grab_focus()
	

func TimerTimeout():
	seconds -= 1
	quizTimerForPlayer -= 1
	if seconds == -1:
		#seconds = QuizTime
		$Node/VideoPlayer.set_visible(false)
		#index += 1
		fail_quiz()
	if seconds == 5:
		$Node/CountPanel/RightNowVideoCount.hide()
		$Node/CountPanel/AllVideosCount.hide()
		$Node/VideoPlayer.show()
	#print( minutes, " : ", str(seconds).pad_zeros(2) )
	#$Node/Label.set_text(str(str(seconds))) # отображать таймер сверху
	$Node/question_info/txt.set_text(str(str(quizTimerForPlayer))) # отображать таймер в описании к квесту
	#$Node/question_info/txt.set_text(str(str(seconds)))
	

# кнопка buttons_restart выход в главное меню
func _on_buttons_restart_pressed():
	UiSound.play()
	queue_free()
	get_tree().change_scene("res://src/scenes/MainMenu/Menu.tscn")

# кнопка buttons_again переиграть игру
func _on_buttons_again_pressed():
	UiSound.play()
	if MultiThreadVar:
		get_tree().reload_current_scene()
	else:
		queue_free()
		get_tree().change_scene("res://src/scenes/Game/main.tscn")

func main_on_skip_pressed():
	UiSound.play()
	timer.start()
	fail_quiz()
	
func fail_quiz():
	for bt in buttons:
		bt.modulate = Color.white
		bt.disabled = true
		bt.disconnect("pressed", self, "buttons_answer")
	question_video.stop()
	question_video.stream = null
	seconds = QuizTime
	quizTimerForPlayer = QuizTime - 5
	index += 1
	load_quiz()


func _on_returnBack_pressed():
	UiSound.play()
	#get_tree().change_scene("res://src/scenes/MainMenu/Menu.tscn")
	$Node/returnBack.set_visible(false)
	question_video.stop()
	question_video.stream = null
	timer.stop()
	game_over()



