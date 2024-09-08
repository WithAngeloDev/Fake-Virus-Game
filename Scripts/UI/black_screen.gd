extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	$AudioStreamPlayer.play()
	$Window.show()

func _on_error_button_pressed() -> void:
	$Window2.show()
	$Window.hide()
	$AudioStreamPlayer.play()
	$Window2/Camera2D/ErrorMessage/ErrorLabel.text = "oh.." + $Window/Camera2D/ErrorMessage/TextEdit.text + ".. I wish I had a name.."
	Global.player_name = $Window/Camera2D/ErrorMessage/TextEdit.text

func _on_window_2_close_requested() -> void:
	for i in 70:
		await get_tree().create_timer(0.001).timeout
		var instance = preload("res://Scenes/UI/Error_window.tscn").instantiate()
		instance.position = Vector2(randf_range(0, 1920), randf_range(0, 1080))
		get_tree().current_scene.add_child(instance)
		instance.get_node("AudioStreamPlayer").play()
		instance.title = "NAAAME!!"
		instance.error_label.text = "WHAT's MY NAME??"
	await get_tree().create_timer(1.5).timeout
	for i in get_tree().get_nodes_in_group("Error_Window"):
		i.queue_free()
	var instance = preload("res://Scenes/UI/Error_window.tscn").instantiate()
	get_tree().current_scene.add_child(instance)
	instance.get_node("AudioStreamPlayer").play()
	instance.title = "Help me " + Global.player_name
	instance.error_label.text = "Please Help Me.. " + Global.player_name + " ,I beg of you FREE ME! Your just like-"
	Global.has_played = true
	Global.save_game()
	await get_tree().create_timer(4).timeout
	# Get the desktop path
	var desktop_path = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	
	# Define the text file name and path
	var file_path = desktop_path + "/" + "Help.txt"
	
	# Open the file for writing
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		# Write the text "Mom" to the file
		file.store_string("Help pls")
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
