extends Control
const songListScene = preload("res://scenes/song_list_item.tscn")
@onready var song_list: VBoxContainer = $SongList
@onready var currently_playing: Label = $CurrentlyPlaying

func _on_ready():
	SqlController.refreshDatabase()
	generateSongRows()
	AppState.connect("current_song", func(song: SongModel): currently_playing.text = song.song_name)
	
func generateSongRows() -> void:	
	for child in song_list.get_children(false):
		song_list.remove_child(child)
	for songDict in SqlController.getAllSongs():
		generateChild(SongModel.buildFromDict(songDict))

func generateChild(song: SongModel):
	var child: SongListItem = songListScene.instantiate()
	child.buildSongListItem(song)
	song_list.add_child(child)


func _on_currently_playing_ready() -> void:
	pass
