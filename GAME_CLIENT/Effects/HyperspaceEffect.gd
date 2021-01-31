extends Node2D

var cpuList = []

export var autostart = false
export var deg = 1
var tweenvals = [250,1]
var timervals = [4, 4]
var complete = false
var cg : Gradient
var cgL = []
var vel = 150
var active = true
var t2 = false

func _ready():
	active = false
	
	$Tween2.interpolate_property(self, 'vel',
		250, 50, 8,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	for c in get_children():
		if 'cpu' in c.name:
			cpuList.append(c)
	
	flipColorP(false)
	createGradients()
	
	if autostart:
		start()

func flipColorP(b):
	cpuList[3].visible = b
	cpuList[4].visible = b
	cpuList[5].visible = b
	cpuList[6].visible = b
	cpuList[7].visible = b

func createGradients():
	#white
	cg = Gradient.new()
	cg.add_point(1,Color(1,1,1,1))
	cg.add_point(100,Color(0.7,0.3,0.8,1))
	cgL.append(cg)
	cgL.append(cg)
	cgL.append(cg)
	#pink
	cg = Gradient.new()
	cg.add_point(1,Color(1,1,1,1))
	cg.add_point(100,Color(01, 0.3,0.3,1))
	cgL.append(cg)
	#blue
	cg = Gradient.new()
	cg.add_point(1,Color(1,1,1,1))
	cg.add_point(100,Color(0.4,0.3,1,1))
	cgL.append(cg)
	#green
	cg = Gradient.new()
	cg.add_point(1,Color(1,1,1,1))
	cg.add_point(100,Color(0.2,1,0.5,1))
	cgL.append(cg)
	#red
	cg = Gradient.new()
	cg.add_point(1,Color(1,1,1,1))
	cg.add_point(100,Color(1,0.2,0.8,1))
	cgL.append(cg)
	#yellow
	cg = Gradient.new()
	cg.add_point(1,Color(1,1,1,1))
	cg.add_point(100,Color(1,1,0.3,1))
	cgL.append(cg)

func start():
	active = true
	flipColorP(true)
	swapTween()

func _process(_delta):
	var i = 0
	for cpu in cpuList:
		#if !active:
		#	cpu.lifetime = vel/5
		#else:
		cpu.lifetime = 32/(deg+1)
		cpu.scale.x = deg*2
		cpu.color = cgL[i].interpolate(deg)
		cpu.initial_velocity = vel
		i += 1

func swapTween():
	tweenvals.invert()
	timervals.invert()
	$Tween.interpolate_property(self, 'deg',
	tweenvals[0], tweenvals[1], timervals[0],
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
	if deg > 10 :
		swapTween()
	else :
		flipColorP(false)
		t2 = true
		$Tween2.start()

func _on_Tween2_tween_completed(_object, _key):
	active = false

func _on_DebugActivate_button_up():
	if !active :
		start()
	else:
		print('already in hyperspace')
