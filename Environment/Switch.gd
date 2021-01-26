extends Node2D

export var linkTo = ''
var linkToNode
export var isOn = false
var active = true
var canflip = false

var lpos = [Vector2(-6,-1), Vector2(9,-1)]

func _ready():
	linkToNode = get_parent().get_node(linkTo)
	colorLight()

func _on_ActivationArea_body_entered(body):
	if body.name == 'Player' : 
		canflip = true

func _on_ActivationArea_body_exited(body):
	if body.name == 'Player' : 
		canflip = false
		
func _unhandled_key_input(event):
	if canflip and event.is_action_pressed('e_active'):
		linkToNode.openclose()

func colorLight():
	if !active:
		$light.self_modulate = Color.green
		$light.position = lpos[0]
	else:
		$light.self_modulate = Color.red
		$light.position = lpos[1]
