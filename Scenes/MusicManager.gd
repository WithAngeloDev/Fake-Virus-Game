extends Node2D


func play(song: AudioStream):
	$AudioStreamPlayer.stream = song
	$AudioStreamPlayer.play()

func stop():
	$AudioStreamPlayer.stop()
