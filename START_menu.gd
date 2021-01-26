extends Control

func _ready():
	FadeIn()

func _on_start_button_up():
	FadeToBlack()
	LEAVEMAIN = true
	get_parent().loadMainScene("res://Scene1.tscn")

func _on_quit_button_up():
	get_tree().quit()

func FadeIn():
	$CL/FadePanel.visible = true
	$Tween.interpolate_property($CL/FadePanel, 'color',
		Color(0,0,0,1), Color(0,0,0,0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

var LEAVEMAIN = false
func FadeToBlack():
	$Tween.interpolate_property($CL/FadePanel, 'color',
		Color(0,0,0,0), Color(0,0,0,1),3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
	if LEAVEMAIN: self.queue_free()

func _on_host_button_up():
	get_parent().initSERVER()

func _on_join_button_up():
	get_parent().initCLIENT()
