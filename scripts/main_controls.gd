class_name MainControls extends VBoxContainer
@onready var h_scroll_bar: HScrollBar = $HScrollBar

func _process(_delta: float):
	if (MusicPlayer.stream && MusicPlayer.playing):
		h_scroll_bar.value = MusicPlayer.get_playback_position() / MusicPlayer.stream.get_length() * h_scroll_bar.max_value

func _on_play_pause_btn_pressed() -> void:
	MusicPlayer.playPause()

func _on_previous_btn_pressed() -> void:
	MusicPlayer.prev()

func _on_next_btn_pressed() -> void:
	MusicPlayer.next()

func _on_h_scroll_bar_gui_input(event: InputEvent) -> void:
	if event.is_action("mb_click"):
		var posPct = event.position.x / h_scroll_bar.size.x
		MusicPlayer.seekToPct(posPct)
