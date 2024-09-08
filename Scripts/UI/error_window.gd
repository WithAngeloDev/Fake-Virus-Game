extends Window

@onready var error_label: Label = $Camera2D/ErrorMessage/ErrorLabel

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
	error_label.text = error_messages.pick_random()
	title = error_messages.pick_random()

func _on_error_button_pressed() -> void:
	clone()

func _on_close_requested() -> void:
	clone()

func clone():
	var instance = preload("res://Scenes/UI/Error_window.tscn").instantiate()
	instance.position = Vector2(randf_range(0,1920),randf_range(0,1080))
	get_tree().current_scene.add_child(instance)
	$AudioStreamPlayer.play()
