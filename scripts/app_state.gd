extends Node
var currentSong
signal current_song

func setCurrentSong(song: SongModel):
	currentSong = song
	current_song.emit(song)
