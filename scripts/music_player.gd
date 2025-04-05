extends AudioStreamPlayer2D
var pausedPosition = 0

func _process(delta: float) -> void:
	pass

func playPause():
	if MusicPlayer.playing:
		pausedPosition = MusicPlayer.get_playback_position()
		MusicPlayer.stop()
	else:
		MusicPlayer.play(pausedPosition)

func prev():
	MusicPlayer.seek(0)

func next():
	print("next not impl")

func seekToPct(pct: float):
	if (MusicPlayer.playing):
		MusicPlayer.seek(pct * MusicPlayer.stream.get_length())
