extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = '127.0.0.1'
var port = 1910

var username
var password

func _ready():
	pass
	
func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return;
	custom_multiplayer.poll();

func ConnectToServer(_username, _password):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")

func _OnConnectionFailed():
	print("Failed to connect to login server")
	print("Service offline or something")
	# join button enable
	get_node("../Game1/Map/START_menu/join").disabled = false
func _OnConnectionSucceeded():
	print("Successfully Connected to Login Server")
	RequestLogin()

func RequestLogin():
	print("Connecting to gateway to request login")
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""

remote func ReturnLoginRequest(results, pid):
	print("results received")
	if results == true:
		GameServer.ConnectToServer()
		get_node("../Game1/Map/START_menu").queue_free()
	else:
		print("Please provide correct username and password")
		get_node("../Game1/Map/START_menu/join").disabled = false
	network.disconnect("connection_failed", self, "_OnConnectionFailed")
	network.disconnect("connection_succeeded", self, "_OnConnectionSucceeded")
