extends Node

onready var player_container_scene = preload("res://Scenes/Instances/PlayerContainer.tscn")

func start(pid):
	pass#CreatePlayerContainer(pid)
	
func CreatePlayerContainer(pid):
	var new_pc = player_container_scene.instance()
	new_pc.name = str(pid)
	get_parent().add_child(new_pc, true)
	var pc = get_node('../' + str(pid))
	FillPlayerContainer(pc)

func FillPlayerContainer(pc):
	pc.player_stats = ServerData.test_data.Stats
