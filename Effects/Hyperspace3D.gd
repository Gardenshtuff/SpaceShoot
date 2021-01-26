extends Spatial

export var autostart = false
var timervals = [4, 6]
var scalevals = [12, 0.4]
var offsetvals = [-38, 0]
var rvals = [Vector3(0,0,0), Vector3(0,90,0)]
var rtime = [2.5, 8]
var sc = 0.4
var offset = 0
var sl = []

func _ready():
	for s in get_children():
		if 'Sprite3D' in s.name:
			sl.append(s)
	for s in sl:
		s.scale.x = sc
		s.translation.z = offset
	$Camera.rotation_degrees.y = 90
	if autostart:
		start()

func start():
	$Viewport/Hyperspace.start()
	swapTween()
	swapTweenR()

func swapTween():
	scalevals.invert()
	timervals.invert()
	offsetvals.invert()
	$TweenScale.interpolate_property(self, 'sc',
	scalevals[0], scalevals[1], timervals[0],
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenOffset.interpolate_property(self, 'offset',
	offsetvals[0], offsetvals[1], timervals[0],
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$TweenScale.start()
	$TweenOffset.start()

func swapTweenR():
	rvals.invert()
	rtime.invert()
	$TweenR.interpolate_property($Camera, 'rotation_degrees',
	rvals[0], rvals[1], rtime[0],
	Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$TweenR.start()
	
func _process(_delta):
	#$Camera.rotation_degrees.y = 90/(sc*2)
	$ShipScene.scale = Vector3(0.2, 0.2, 0.2) * 0.4/sc
	$CSGCylinder.translation.z = offset - 4.5
	for s in sl:
		s.scale.x = sc
		s.translation.z = offset

func _on_TweenScale_tween_completed(_object, _key):
	if sc > 1:
		swapTween()

func _on_TweenOffset_tween_completed(_object, _key):
	if offset > 1:
		pass #swapTween()

func _on_Control_button_up():
	start()

func _on_TweenR_tween_completed(_object, _key):
	if $Camera.rotation_degrees.y < 10:
		swapTweenR()
