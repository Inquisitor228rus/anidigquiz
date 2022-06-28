extends CanvasLayer

signal transitioned

func fadein():
	$Shader/AnimationPlayer.play("fade_in")
	emit_signal("transitioned")
	#$AnimationPlayer.play("fade_in")
	
func fadeout(time : float):
	$AnimationPlayer.play("fade_out", -1, time)
	#yield(get_tree().create_timer(time), "timeout")

func SceneChanger(Scene, time):
	fadein()
	get_tree().change_scene(Scene)
	fadeout(time)
