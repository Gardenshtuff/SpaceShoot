extends Node

var ip = '127.0.0.1'
var port = 1909
var network = NetworkedMultiplayerENet.new()

func _ready():
	pass

signal connection_succeeded
signal connection_failed

func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	get_tree().connect('connection_failed', self, '_on_player_disconnected')
	get_tree().connect('connection_suceeded', self, '_on_player_connected')

func _on_player_disconnected():
	print('Failed to connect')
func _on_player_connected():
	print('Connected to server')

func FetchData(s_name, requester):
	rpc_id(1, "FetchData", s_name, requester)
remote func ReturnFetchData(s_dat, requester):
	instance_from_id(requester).SetDamage(s_dat)
