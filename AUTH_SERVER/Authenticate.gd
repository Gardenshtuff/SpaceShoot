#extends Node
#
#var network = NetworkedMultiplayerENet.new() 
#var ip = '127.0.0.1'
#var port = 1911
#var max_players = 5
#
#func _ready():
#	StartServer()
#
#func StartServer():
#	network.create_server(port, max_players)
#	get_tree().set_network_peer(network)
#	print("Auth server started")
#
#	network.connect("connection_failed", self, "_Peer_Connected")
#	network.connect("connection_succeeded", self, "_Peer_Disconnected")
#
#func _Peer_Connected(gateway_id):
#	print("gateway " + str(gateway_id) + " connected")
#func _Peer_Disconnected(gateway_id):
#	print("gateway " + str(gateway_id) + " disconnected")
#
#remote func AuthenticatePlayer(username, password, pid):
#	print("auth request received")
#	var gateway_id = get_tree().get_rpc_sender_id()
#	var result
#
#	if not PlayerData.PlayerIDs.has(username):
#		print("user does not exist")
#		result = false
#	elif not PlayerData.PlayerIDs[username] == password:
#		print("password incorrect")
#		result = false
#	else:
#		print("auth success")
#		result = true
#	print("sending auth results back")
#	rpc_id(gateway_id, "AuthenticationResults", result, pid)
#
