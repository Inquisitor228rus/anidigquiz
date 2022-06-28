extends Node

enum QuestionType { VIDEO }

export(Resource) var bd_quiz
export(Color) var color_right
export(Color) var color_wrong

var buttons := []
var index := 0
var quiz_shuffle := []
var correct := 0
var QuizTime = Settings.QuizTime
var answers := 0

var newArr := []
# timer
var timer
var seconds: int = QuizTime
var quizTimerForPlayer = QuizTime - 5
var Full_Opening
# end timer

var my_data = {"Score":0}
func update_score(new_score):
	my_data["Score"] = new_score
	if (new_score % 10 == 0):
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
	quiz_shuffle = randomize_array(bd_quiz.bd)
	load_quiz()
	timer = Timer.new()
	timer.connect("timeout",self,"TimerTimeout") 
	timer.set_wait_time(1) #value is in seconds: 600 seconds = 10 minutes
	timer.set_one_shot(false)
	add_child(timer) 
	timer.start() 
	$Node/question_buttons/VBoxContainer/Button.grab_focus()
	randomize_array_in_start()
	
func load_quiz() -> void:
	#if index >= bd_quiz.bd.size():
	if index >= 15:
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
	var options = randomize_array(bd_quiz.bd[index].options)
	
	for i in buttons.size():
		buttons[i].text = str(options[i])
		buttons[i].connect("pressed", self, "buttons_answer", [buttons[i]])
	
	match bd_quiz.bd[index].type:
		QuestionType.VIDEO:
			
			question_video.stream = bd_quiz.bd[index].question_video
			question_video.play()
		
func buttons_answer(button) -> void:
	if bd_quiz.bd[index].correct == button.text:
		button.modulate = color_right
		correct += 1
		update_score(correct)
		$ErrPanel.write_message(str(correct))
	else:
		button.modulate = color_wrong
	
	for bt in buttons:
		bt.disabled = true
		
	
	var timer_seconds = seconds
	seconds = QuizTime
	quizTimerForPlayer = QuizTime - 5
	$Node/question_info/txt.set_text("")
	yield(get_tree().create_timer(1), "timeout")
	$Node/VideoPlayer.show()
	timer.stop()
	yield(get_node("Node/VideoPlayer"), "finished")
	timer.start()
	#yield(get_tree().create_timer(30 - $Node/VideoPlayer.get_stream_position()), "timeout")
	
	$Node/VideoPlayer.set_visible(false)
	question_video.stop()
	for bt in buttons:
		bt.modulate = Color.white
		bt.disconnect("pressed", self, "buttons_answer")
		
	question_video.stream = null
	index += 1
	load_quiz()

func randomize_array(array: Array) -> Array:
	randomize()
	newArr = array
	print(array.size())
	var array_temp := newArr
	array_temp.shuffle()
	return array_temp

func randomize_array_in_start():
	
	var array = range(0,15)
	var i : int = array.size() - 1
	while i >= 0:
		print(array[i])
		i -= 1


func game_over() -> void:
	$Node/game_over.show()
	$Node/returnBack.hide()
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
		$Node/VideoPlayer.show()
	#print( minutes, " : ", str(seconds).pad_zeros(2) )
	#$Node/Label.set_text(str(str(seconds))) # отображать таймер сверху
	$Node/question_info/txt.set_text(str(str(quizTimerForPlayer))) # отображать таймер в описании к квесту
	#$Node/question_info/txt.set_text(str(str(seconds)))
	


func _on_buttons_restart_pressed():
	queue_free()
	get_tree().change_scene("res://src/scenes/MainMenu/Menu.tscn")
	


func main_on_skip_pressed():
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
	#get_tree().change_scene("res://src/scenes/MainMenu/Menu.tscn")
	$Node/returnBack.set_visible(false)
	question_video.stop()
	question_video.stream = null
	timer.stop()
	game_over()
