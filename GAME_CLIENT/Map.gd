extends Node2D

var player_spawn = preload("res://Player/ServerPlayer.tscn")

func SpawnClientPlayer(pid, pos):
	var np = load("res://Player/Player.tscn").instance()
	np.global_position = pos
	np.name = str(pid)
	get_node("YSort").add_child(np)

func SpawnNewPlayer(pid, pos):
	if get_tree().get_network_unique_id() == pid:
		pass
	else:
		var np = player_spawn.instance()
		np.global_position = pos
		np.name = str(pid)
		get_node("YSort/OtherPlayers").add_child(np)

func DespawnPlayer(pid):
	get_node("YSort/OtherPlayers/" + str(pid)).queue_free()
