extends Node2D

func _ready() -> void:
	Global.many_times_opened = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlatformerController:
		$PhantomCamera2D2.priority_override = true
		$PhantomCamera2D2.priority = 1000

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body is PlatformerController:
		get_tree().reload_current_scene()
