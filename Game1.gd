extends Node

var new_player

func _ready():
	var _u
	_u = get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	_u = get_tree().connect('server_disconnected', self, '_on_server_disconnected')

func _on_player_disconnected(id):
	get_node(str(id)).queue_free()

func _on_server_disconnected():
	var _u = get_tree().change_scene('res://Game1.tscn')

var onboardScene
func loadScene(s):
	onboardScene = load(s).instance()
func swapScene():
	add_child(onboardScene)
	if is_network_master():
		Network.current_scene = onboardScene.name

func spawnPlayer(pos):
	new_player = preload('res://Player/Player.tscn').instance()
	new_player.name = str(get_tree().get_network_unique_id())
	new_player.set_network_master(get_tree().get_network_unique_id())
	var info = Network.self_data
	new_player.init(info.position)
	add_child(new_player)
	new_player.global_position = pos

func initSERVER_G(player_nickname):
	Network.create_server(player_nickname)
	add_child(load('res://Lobby1.tscn').instance())
	remove_child(get_child(0))
	
	new_player = preload('res://Player/Player.tscn').instance()
	new_player.name = str(get_tree().get_network_unique_id())
	new_player.set_network_master(get_tree().get_network_unique_id())
	add_child(new_player)
	var info = Network.self_data
	new_player.init(info.name, info.position)

func initCLIENT_G(player_nickname):
	Network.connect_to_server(player_nickname)
	add_child(load('res://Lobby1.tscn').instance())
	remove_child(get_child(0))
	
	new_player = preload('res://Player/Player.tscn').instance()
	new_player.name = str(get_tree().get_network_unique_id())
	new_player.set_network_master(get_tree().get_network_unique_id())
	add_child(new_player)
	var info = Network.self_data
	new_player.init(info.name, info.position)
