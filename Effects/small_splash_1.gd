extends Node2D

func _on_Timer_timeout():
	get_parent().remove_child(self)
