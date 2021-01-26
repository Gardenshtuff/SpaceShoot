extends Node2D

var entity
export var disabled = false
func _ready():
	entity = load('res://Enemy/CloudBuddy.tscn')

func _on_SpawnTimer_timeout():
	if(!disabled): Spawn()
	
func Spawn():
	var e = entity.instance()
	e.global_position = global_position
	get_parent().add_child(e)

