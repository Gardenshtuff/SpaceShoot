extends Node2D

var LRval = [0, PI+PI]
var LRtime = 2.0
var UDval = [Vector2(30,0), Vector2(10,0)]

func _ready():
	LRstart()
	UDstart()

func _on_LRTween_tween_completed(_object, _key):
	#LRval.invert()
	#LRstart()
	pass

func _on_UDTween_tween_completed(_object, _key):
	UDval.invert()
	UDstart()

func LRstart():
	$LRTween.interpolate_property($Axis, "rotation",
		LRval[0], LRval[1], LRtime,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LRTween.start()

func UDstart():
	$UDTween.interpolate_property($Axis/Sprite, "position",
		UDval[0], UDval[1], float(LRtime/4.0),
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$UDTween.start()
