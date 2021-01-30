extends Node2D

func _process(_delta):
	if is_network_master():
		position = get_global_mouse_position() - get_parent().position
	
