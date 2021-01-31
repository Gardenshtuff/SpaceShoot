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
