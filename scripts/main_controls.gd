class_name MainControls extends VBoxContainer

func _on_play_pause_btn_pressed() -> void:
	MusicPlayer.playPause()

func _on_previous_btn_pressed() -> void:
	MusicPlayer.prev()

func _on_next_btn_pressed() -> void:
	MusicPlayer.next()
