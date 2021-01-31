extends Node

var ip = '127.0.0.1'
var port = 1911
var network = NetworkedMultiplayerENet.new()

func _ready():
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)

	get_tree().connect('connection_failed', self, '_OnConnectionFailed')
	get_tree().connect('connection_succeeded', self, '_OnConnectionSucceeded')

func _OnConnectionFailed():
	print('Failed to connect to authentication server')
func _OnConnectionSucceeded():
	print('Connected to authentication server')
	
func AuthenticatePlayer(username, password, pid):
	print("Sending out authentication request")
	rpc_id(1, "AuthenticatePlayer", username, password, pid)
	
remote func AuthenticationResults(result, pid):
	print("results received and replying to player login request")
	Gateway.ReturnLoginRequest(result, pid)
