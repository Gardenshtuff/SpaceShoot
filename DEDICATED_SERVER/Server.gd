extends Node

var port = 1909
const max_players = 100

var network = NetworkedMultiplayerENet.new()

func _ready():
	StartServer()
	
func StartServer():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print('server started')
	var _u = network.connect('peer_disconnected', self, '_Peer_Disconnected')
	_u = network.connect('peer_connected', self, '_Peer_Connected')
	
func _Peer_Disconnected(pid):
	#players.erase(pid)
	#current_num_players -= 1
	#$'/root/Monitor/pnum'.text = str(current_num_players)
	print("User " + str(pid) + " disconnected")
	#if has_node(str(pid)):
	#	get_node(str(pid)).queue_free()
	#	rpc_id(0,"DespawnPlayer", pid)

#var current_num_players = 0
func _Peer_Connected(pid):
	#var local_player_id = get_tree().get_network_unique_id()
	#if not(get_tree().is_network_server()):
	#	rpc_id(1, '_request_player_info', local_player_id, pid)
	#current_num_players += 1
	#$'/root/Monitor/pnum'.text = str(current_num_players)
	print("User " + str(pid) + " connected")

remote func FetchData(s_name, requester):
	var pid = get_tree().get_rpc_sender_id()
	var damage = $Combat.FetchSkillDamage(s_name)
	rpc_id(pid, "ReturnFetchData", damage, requester)

###
#func FetchToken(pid):
#	pass
#remote func ReturnToken(token):
#	pass
#
#func ReturnTokenVerificationResults(pid, result):
#	rpc_id(pid, "ReturnTokenVerificationResults", result)
#	#if result:
#	#rpc_id(0, "SpawnClientPlayer", pid, Vector2(0,20))
#
#func SendPlayerState(p_state):
#	print(p_state)
#	rpc_unreliable_id(1, "ReceivePlayerState", p_state)
#
#func ReceivePlayerState(p_state):
#	var play_id = get_tree().get_rpc_sender_id()
#	if players.has(play_id):
#		if players[play_id]["T"] < p_state["T"] :
#			players[play_id] = p_state
#	else:
#		players[play_id] = p_state
