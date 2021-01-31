extends Node

var PlayerIDs

func _ready():
	var p_data_file = File.new()
	p_data_file.open("res://Data/PlayerData.JSON", File.READ)
	var p_data_json = JSON.parse(p_data_file.get_as_text())
	p_data_file.close()
	PlayerIDs = p_data_json.result
