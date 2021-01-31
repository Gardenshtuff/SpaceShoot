extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1910
var max_players = 100

func _ready():
	StartServer()
	
func _process(_delta):
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();

func StartServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("Gateway Server Started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(pid):
	print("User " + str(pid) + " Connected")
func _Peer_Disconnected(pid):
	print("User " + str(pid) + " Disconnected")

remote func LoginRequest(username, password):
	print("login request received")
	var pid = custom_multiplayer.get_rpc_sender_id()
	Authenticate.AuthenticatePlayer(username, password, pid)

func ReturnLoginRequest(result, pid):
	rpc_id(pid, "ReturnLoginRequest", result, pid)
	network.disconnect_peer(pid)
