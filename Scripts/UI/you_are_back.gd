extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Window/AudioStreamPlayer.play()
	$Window/Camera2D/ErrorMessage/ErrorLabel.text = "Why are you back " + Global.player_name + "?"
	MusicManager.play(preload("res://Audio/Music/VirusMusic.mp3"))
	Global.many_times_opened = 2
	Global.save_game()

func _on_window_close_requested() -> void:
	hide()
	$Window/AudioStreamPlayer.play()
	# Get the desktop path
	var desktop_path = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	
	# Define the text file name and path
	var file_path = desktop_path + "/" + "StopRunning.txt"
	
	# Open the file for writing
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		# Write the text "Mom" to the file
		file.store_string("Go AWAY")
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

func _on_error_button_pressed() -> void:
	$Window.hide()
	$Window/AudioStreamPlayer.play()
	# Get the desktop path
	var desktop_path = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	
	# Define the text file name and path
	var file_path = desktop_path + "/" + "StopRunning.txt"
	
	# Open the file for writing
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		# Write the text "Mom" to the file
		file.store_string("Go AWAY")
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
