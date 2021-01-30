extends Control

func _ready():
	FadeIn()

func _on_start_button_up():
	FadeToBlack()
	LEAVEMAIN = true
	get_parent().loadScene("res://Scene1.tscn")
	setButtons(true)

func _on_quit_button_up():
	get_tree().quit()


func setButtons(b):
	$start.disabled = b
	$quit.disabled = b
	#$load.disabled = b
	$join.disabled = b
	$host.disabled = b

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
	if LEAVEMAIN: 
		#get_parent().spawnPlayer(Vector2(0,0))
		get_parent().swapScene()
		self.queue_free()

func _on_host_button_up():
	get_parent().initSERVER_G($IP_ENTER/text.text, int($PORT_ENTER/text.text), $ID_ENTER/text.text)

func _on_join_button_up():
	get_parent().initCLIENT_G($IP_ENTER/text.text, int($PORT_ENTER/text.text), $ID_ENTER/text.text)

func _on_pingHost_button_up():
	pass # Replace with function body.

var strmax = 13
func _on_text_text_changed():
	if $ID_ENTER/text.text.length() > strmax:
		$ID_ENTER/text.readonly = true

func _input(_event):
	if Input.is_action_just_pressed("backspace") and $ID_ENTER/text.readonly:
		$ID_ENTER/text.text = $ID_ENTER/text.text.substr(0,strmax)
		$ID_ENTER/text.readonly = false
