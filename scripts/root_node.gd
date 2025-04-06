extends Control
const songListScene = preload("res://scenes/song_list_item.tscn")
@onready var song_list: VBoxContainer = $SongList
@onready var currently_playing: Label = $CurrentlyPlaying

func _on_ready():
	SqlController.refreshDatabase()
	generateSongRows()
	
func generateSongRows() -> void:	
	for child in song_list.get_children(false):
		song_list.remove_child(child)
	for songDict in SqlController.getAllSongs():
		generateChild(SongModel.buildFromDict(songDict))

func generateChild(song: SongModel):
	var child: SongListItem = songListScene.instantiate()
	child.buildSongListItem(song, play_song)
	song_list.add_child(child)
	
func play_song(song: SongModel):
	MusicPlayer.stop()
	currently_playing.text = song.song_name
	
	var audio_stream = AudioStreamMP3.load_from_file("res://assets/songs/" + song.file_name)
	MusicPlayer.stream = audio_stream
	MusicPlayer.play()

func _on_audio_stream_player_2d_finished() -> void:
	pass # Replace with function body.
