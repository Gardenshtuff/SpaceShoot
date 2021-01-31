extends Node2D

export var OneShot = false
export var AAradius = 60
var canflip = false
var active = false
signal sig

func _ready():
	$AA/CollisionShape2D.shape.radius = AAradius
	colorLight()

func _on_AA_body_entered(body):
	if body.name == 'Player': 
		canflip = true
	if(OneShot and active):
		canflip = false

func _on_AA_body_exited(body):
	if body.name == 'Player' : 
		canflip = false
		
func _unhandled_key_input(event):
	if canflip and event.is_action_pressed('e_active'):
		active = !active
		colorLight()
		if active:
			emit_signal('sig')
		elif OneShot:
			emit_signal('sig')
			canflip = false

var lpos = [Vector2(-6,-1), Vector2(9,-1)]

func colorLight():
	if active:
		$light.self_modulate = Color.green
		$light.position = lpos[0]
	else:
		$light.self_modulate = Color.red
		$light.position = lpos[1]
