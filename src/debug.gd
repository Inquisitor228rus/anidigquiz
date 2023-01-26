extends VBoxContainer

onready var fps_label := $fps_label
onready var fps_label2 := $fps_label2
onready var fps_label3 := $fps_label3
onready var fps_label4 := $fps_label4
onready var fps_label5 := $fps_label5
onready var fps_label6 := $fps_label6
onready var fps_label7 := $fps_label7

var safety = false


func _process(_delta):
	#fps_label += "fps: " + str(Engine.get_frames_per_second())
	fps_label.set_text("fps: " + str(Engine.get_frames_per_second()))
	if Input.is_action_just_released("debug"):
		safety = !safety
		visible = !safety
		
