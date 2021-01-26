extends Node2D

var canopen = false
export var locked = false
export var switch_CTRL_ONLY = false
export var switches = ['']
var SW_CTRL = []

func _ready():
	for s in switches:
		SW_CTRL.append(get_parent().get_node(s))

func _on_ActivationArea_body_entered(body):
	if body.name == 'Player' : 
		canopen = true

func _on_ActivationArea_body_exited(body):
	if body.name == 'Player' : 
		canopen = false
		
func _unhandled_key_input(event):
	if locked :
		print('door locked!')
	elif canopen and !switch_CTRL_ONLY and !locked and event.is_action_pressed('e_active'):
		openclose()

func openclose():
	var b = !$Sprite.visible
	for s in SW_CTRL:
		s.active = b
		s.colorLight()
	$Sprite.visible = b
	$StaticBody2D/CollisionShape2D.disabled = !b
	$StaticBody2D.visible = b
