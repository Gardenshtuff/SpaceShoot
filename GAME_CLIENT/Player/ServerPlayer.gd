extends KinematicBody2D

var puppet_vel = Vector2(0,0)

func _ready():
	pass
	
func init(_nickname, start_position):
	#$GUI/Nickname.text = nickname
	global_position = start_position

func _physics_process(_delta):
	pass#global_position = Network.players[int(name)].position
	#var _u = move_and_slide(puppet_vel)
