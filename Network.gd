extends Node

var SERVER_PORT = 31400
var MAX_PLAYERS = 4
var SERVER_IP = '127.0.0.1'

func initSERVER():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	print(get_tree().network_peer)

func initCLIENT():
	var peer = NetworkedMultiplayerENet.new()
	SERVER_IP = IP.get_local_addresses()[0]
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	print(get_tree().network_peer)

func _ready():
	var _s = get_tree().connect("network_peer_connected", self, "_player_connected")
	_s = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	_s = get_tree().connect("connected_to_server", self, "_connected_ok")
	_s = get_tree().connect("connection_failed", self, "_connected_fail")
	_s = get_tree().connect("server_disconnected", self, "_server_disconnected")

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }

func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", my_info)
	print('%s connected'%id)

func _player_disconnected(id):
	player_info.erase(id) # Erase player from info.
	print("%s disconnected"%id)

func _server_disconnected():
	print('Error: Server Disconnected')

func _connected_fail():
	print('Abort: Connection Failed')

remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info

	# Call function to update lobby UI here
var level_to_load = 'res://Scene1.tscn'
remote func pre_configure_game():
	get_tree().set_pause(true) # Pre-pause
	var selfPeerID = get_tree().get_network_unique_id()

	# Load world
	var world = load(level_to_load).instance()
	get_node("/root").add_child(world)

	# Load my player
	var my_player = preload('res://Player/Player.tscn').instance()
	my_player.set_name(str(selfPeerID))
	my_player.set_network_master(selfPeerID) # Will be explained later
	get_node("/root/world/players").add_child(my_player)

	# Load other players
	for p in player_info:
		var player = preload('res://Player/Player.tscn').instance()
		player.set_name(str(p))
		player.set_network_master(p) # Will be explained later
		get_node("/root/world/players").add_child(player)

	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
	# The server can call get_tree().get_rpc_sender_id() to find out who said they were done.
	rpc_id(1, "done_preconfiguring")

var players_done = []
remote func done_preconfiguring():
	var who = get_tree().get_rpc_sender_id()
	# Here are some checks you can do, for example
	assert(get_tree().is_network_server())
	assert(who in player_info) # Exists
	assert(not who in players_done) # Was not added yet

	players_done.append(who)

	if players_done.size() == player_info.size():
		rpc("post_configure_game")

remote func post_configure_game():
	# Only the server is allowed to tell a client to unpause
	if 1 == get_tree().get_rpc_sender_id():
		get_tree().set_pause(false)
		# Game starts now!
