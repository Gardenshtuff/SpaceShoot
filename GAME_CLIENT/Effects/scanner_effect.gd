extends Node2D

var origin
var target

var pv
var c = 1
var i = 1
var starttime = 0
export var debugON = false

func _ready():
	pv = [$M/M1, $M/M2]
	starttime = $ScanTimer.wait_time
	
	#target = get_global_mouse_position() - get_parent().position
	target = get_parent().get_node('Pointer')
	origin = self
	
	set_tweens()
	
func _process(_delta):
	#target = get_global_mouse_position() - get_parent().position
	$M.position = target.position
	$M.look_at(self.global_position)
	update()

func set_tweens():
	pv.invert()
	$Tween.interpolate_property($p1, 'position',
		target.position+pv[0].position, target.position+pv[1].position, starttime/5,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	
func _draw():
	draw_line(origin.position, target.position, Color(0, 0, 1, 0.5), 1)
	draw_line(origin.position, $p1.position, Color(1, 0, 0, c), 1)

func _on_Tween_tween_completed(_object, _key):
	set_tweens()

func _on_Timer_timeout():
	c = c^1

func _on_ScanTimer_timeout():
	if(!debugON):get_parent().remove_child(self)
