extends 'res://Network.gd'

func _ready():
	pass


func loadMainScene(s):
	add_child(load(s).instance())
	current_player = spawnPlayer(Vector2(-150,450))

var current_player = null
func spawnPlayer(pos):
	if current_player == null:
		var p = load("res://Player/Player.tscn").instance()
		add_child(p)
		p.global_position = pos
		return p
	else:
		add_child(current_player)
		current_player.global_position = pos
		return current_player
