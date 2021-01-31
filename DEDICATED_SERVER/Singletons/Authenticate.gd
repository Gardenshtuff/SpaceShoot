extends Node

var network = NetworkedMultiplayerENet.new() 
var ip = '127.0.0.1'
var port = 1911

# Called when the node enters the scene tree for the first time.
func _ready():
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	
func _OnConnectionFailed():
	print("Authentication: Fail")
func _OnConnectionSucceeded():
	print("Authentication: Success")

func _Peer_Connected(gateway_id):
	print("gateway " + str(gateway_id) + " connected")
func _Peer_Disconnected(gateway_id):
	print("gateway " + str(gateway_id) + " disconnected")

#func AuthenticatePlayer(username, password, pid):
#	var token
#	var gateway_id = get_tree().get_rpc_sender_id()
#	var result
#	if not PlayerData.PlayerIDs.has(username):
#		result = false
#	elif not PlayerData.PlayerIDs[username].Password == password:
#		result = false
#	else:
#		result = true
#		randomize()
#		var random_num = randi()
#		var hashed = str(random_num).sha256_text()
#		var timestamp  =str(OS.get_unix_time())
#		token = hashed + timestamp
#		var gameserver = "Server1"
#		GameServers.DistributeLoginToken(token, gameserver)
#	rpc_id(gateway_id, "AuthenticateResults", result, pid, token)
	
	
#remote func funcAuthenticationResults(result, pid):
#	pass
