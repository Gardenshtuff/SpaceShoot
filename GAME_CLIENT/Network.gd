extends Node

const SERVER_NAME = "SERVER1"
const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 5

var players = { }
var self_data = { name = '', position = Vector2(360, 180) }

signal player_disconnected
signal server_disconnected

func _ready():
	var _u = get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	_u = get_tree().connect('network_peer_connected', self, '_on_player_connected')

func create_server(IPin, PORTin, player_nickname):
	self_data.name = player_nickname
	players[1] = self_data
	print("%s created server %s:%s:%s" % [players[1].name, SERVER_NAME, IPin, str(PORTin)])
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORTin, MAX_PLAYERS) # Set port on current IP, and Max players allowed in
	peer.set_bind_ip(IPin)
	get_tree().set_network_peer(peer)
	print(IP.get_local_addresses())

func connect_to_server(IPin, PORTin, player_nickname):
	self_data.name = player_nickname
	print("%s attempting server %s:%s" % [player_nickname, SERVER_NAME, IPin])
	var _u = get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	
	peer.create_client(IPin, PORTin) # Connect to IP : PORT
	get_tree().set_network_peer(peer)

func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	print('local_player_id: %s' % str(local_player_id))
	players[local_player_id] = self_data
	rpc('_send_player_info', local_player_id, self_data)
	print('%s connected to server' % self_data.name)

func _on_player_disconnected(id):
	players.erase(id)
	print('%d disconnected from server' % id)

func _on_player_connected(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)
	print('%d connected to server' % connected_player_id)

remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

# A function to be used if needed. The purpose is to request all players in the current session.
remote func _request_players(request_from_id):
	if get_tree().is_network_server():
		for peer_id in players:
			if( peer_id != request_from_id):
				rpc_id(request_from_id, '_send_player_info', peer_id, players[peer_id])

remote func _send_player_info(id, info):
	players[id] = info
	var new_player 
	new_player = load('res://Player/Player.tscn').instance()
	new_player.get_node('Camera2D').current = false
	new_player.name = str(id)
	new_player.set_network_master(id)
	$'/root/Game1/'.add_child(new_player)
	new_player.init(info.name, info.position)
	print("%s added to game" % new_player.name)

# called from player, to update their 'network' position
func update_position(id, position):
	players[id].position = position

func SendPlayerState(p_state):
	print(p_state)
	rpc_unreliable_id(1, "ReceivePlayerState", p_state)

func ReceivePlayerState(p_state):
	var play_id = get_tree().get_rpc_sender_id()
	if players.has(play_id):
		if players[play_id]["T"] < p_state["T"] :
			players[play_id] = p_state
	else:
		players[play_id] = p_state
