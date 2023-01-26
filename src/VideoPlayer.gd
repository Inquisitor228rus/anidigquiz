extends VideoPlayer


func _ready():
	set_buffering_msec(1500)
	#print(get_buffering_msec ( ))

func _on_VideoPlayer_finished():
	visible = false
	#get_tree().quit()


func _on_skip_pressed():
	visible = false
