extends Control

var velocity = Vector2(-1,0)
var resetPoint = Vector2(600,0)
export var Nlist = []
var NL = []

func _ready():
	for s in Nlist:
		NL.append(get_node(s))
	FadeIn()

func _on_start_button_up():
	FadeToBlack()
	var _u = get_tree().change_scene("res://Game1.tscn")

func _on_quit_button_up():
	get_tree().quit()

func _physics_process(_delta):
	for N in NL:
		var _u = N.move_and_collide(velocity)
		if(N.global_position.x <= -800):
			N.global_position = resetPoint

func streamObj():
	pass

func FadeIn():
	$CL/FadePanel.visible = true
	$Tween.interpolate_property($CL/FadePanel, 'color',
		Color(0,0,0,1), Color(0,0,0,0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func FadeToBlack():
	$Tween.interpolate_property($CL/FadePanel, 'color',
		Color(0,0,0,0), Color(0,0,0,1),3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
