extends Control

var active = false

func _ready():
	var _u = get_tree().get_root().get_node('Game1/CDSW').connect('sig', self, 'startCountDown')
	$RTL.visible = false

func startCountDown():
	#if(code == 'countdown'):
	active = true
	$RTL.visible = true
	$Music.play()
	$Music2.play()
	$Timer.start()

func stopCountDown():
	$Music.stop()
	$Timer.paused = true
	active = false

func _process(_delta):
	if active:
		$RTL.text = String(stepify($Timer.time_left,0.01))


func _on_Timer_timeout():
	get_tree().get_root().get_node('Game1/Player').killPlayer()
