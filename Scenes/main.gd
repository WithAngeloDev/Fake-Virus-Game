extends Control

var has_spawned_errors: bool = false

var error_messages = [
	"System Failure",
	"Critical Error",
	"Memory Overflow",
	"Unknown Exception",
	"Fatal Error",
	"Access Denied",
	"System Crash",
	"Virus Detected",
	"File Corruption",
	"Data Loss Imminent"
]


func _ready() -> void:
	Global.load_game()
	get_tree().get_root().transparent_bg = true
	if Global.has_played:
		if Global.many_times_opened == 1:
			get_tree().change_scene_to_file("res://Scenes/UI/YouAreBack.tscn")
		elif Global.many_times_opened == 2:
			Global.many_times_opened = 3
			Global.save_game()
			get_tree().quit()
		elif Global.many_times_opened == 3:
			Global.many_times_opened = 4
			Global.save_game()
			get_tree().quit()
		elif Global.many_times_opened == 4:
			Global.many_times_opened = 5
			Global.save_game()
				# Get the desktop path
			var desktop_path = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
			
			# Define the text file name and path
			var file_path = desktop_path + "/" + "IamScared.txt"
			
			# Open the file for writing
			var file = FileAccess.open(file_path, FileAccess.WRITE)
			if file:
				# Write the text "Mom" to the file
				file.store_string("I am scared.. there is something WATCHING ME.. HELP ME")
				file.close()
				print("Text file created successfully at: " + file_path)
			
				var success = OS.execute("cmd", ["/c", "start", file_path], [], true)
				if success:
					print("Text file opened successfully.")
				else:
					print("Failed to open the text file.")
			else:
				print("Failed to create the text file.")
			await get_tree().create_timer(1).timeout
			get_tree().quit()
		else:
			get_tree().quit()
	elif Global.many_times_opened == 0:
		get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("Error_Window").size() > 3 && !has_spawned_errors:
		spawn_error_windows()
		has_spawned_errors = true
	if get_tree().get_nodes_in_group("Error_Window").size() >= 70:
		get_tree().change_scene_to_file("res://Scenes/UI/blue_screen.tscn")

func spawn_error_windows():
	for i in 70:
		await get_tree().create_timer(0.001).timeout
		var instance = preload("res://Scenes/UI/Error_window.tscn").instantiate()
		instance.position = Vector2(randf_range(0, 1920), randf_range(0, 1080))
		get_tree().current_scene.add_child(instance)
		instance.get_node("AudioStreamPlayer").play()
		instance.title = error_messages.pick_random()
		instance.error_label.text = error_messages.pick_random()
		var tween = get_tree().create_tween()
