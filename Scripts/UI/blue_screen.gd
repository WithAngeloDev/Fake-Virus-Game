extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("Error_Window").size() >= 70:
		get_tree().change_scene_to_file("res://Scenes/UI/BlackScreen.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Smile":
		MusicManager.play(preload("res://Audio/Music/VirusMusic.mp3"))
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Window.show()
		$Window/AudioStreamPlayer.play()

func _on_window_2_close_requested() -> void:
	$Window/AudioStreamPlayer.play()

func _on_error_button_pressed() -> void:
	$Window2.show()
	$Window/AudioStreamPlayer.play()

func _on_error_button_2_pressed() -> void:
	$Window2.show()
	$Window/AudioStreamPlayer.play()
	await get_tree().create_timer(2).timeout
	spawn_error_windows()

func spawn_error_windows():
	for i in 70:
		await get_tree().create_timer(0.001).timeout
		var instance = preload("res://Scenes/UI/Error_window.tscn").instantiate()
		instance.position = Vector2(randf_range(0, 1920), randf_range(0, 1080))
		get_tree().current_scene.add_child(instance)
		instance.get_node("AudioStreamPlayer").play()
		instance.title = "I 𝑎𝓶 𝐧𝑜𝓉!"
		instance.error_label.text = "I̷̯̤̗͆̋͠ ̶̢̲͉̤̑ȃ̴͖͚̖̌͗̀̐̿m̸̘̝̪̦̻͎̑̽̌̀̆̆͒ ̵̘͎̰͉͉̾̓͛̚n̵̲̼̗͉̓̾̀̎̾̈o̴͖͑͂̽͠t̶̺̲̤͍͔̝̏̐͑̈́͋͋͠!̸̫̈́͝"
		var tween = get_tree().create_tween()
