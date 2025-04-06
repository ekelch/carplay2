extends AudioStreamPlayer2D
var pausedPosition = 0

func loadSong(song: SongModel):
	MusicPlayer.stop()
	var audio_stream = AudioStreamMP3.load_from_file("res://assets/songs/" + song.file_name)
	MusicPlayer.stream = audio_stream
	MusicPlayer.play()
	AppState.setCurrentSong(song)

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
