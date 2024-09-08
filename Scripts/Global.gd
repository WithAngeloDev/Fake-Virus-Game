extends Node

var player_name: String = ""
var has_played: bool = false
var many_times_opened: int = 0

func save():
	var save_dic = {
		"Player_Name" : player_name,
		"Has_Played_Before" : has_played,
		"many_times": many_times_opened
	}
	
	return save_dic

func save_game():
	var save_game = FileAccess.open_encrypted_with_pass("user://NOTAVIRUSSAVING.save", FileAccess.WRITE, "Gwizz")
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://NOTAVIRUSSAVING.save"):
		return
	
	var save_game = FileAccess.open_encrypted_with_pass("user://NOTAVIRUSSAVING.save", FileAccess.READ, "Gwizz")
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_results = json.parse(json_string)
		var node_data = json.get_data()
		
		player_name = node_data["Player_Name"]
		has_played = node_data["Has_Played_Before"]
		many_times_opened = node_data["many_times"]
		
		print(node_data)
