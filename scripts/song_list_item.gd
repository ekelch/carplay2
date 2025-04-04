class_name SongListItem extends Control
const songListScene = preload("res://scenes/song_list_item.tscn")
@export var song_name: Label
@export var artist_name: Label
@export var play_button: Button

static func buildSongListItem(song: SongModel, playFn: Callable) -> SongListItem:
	var songListItem: SongListItem = songListScene.instantiate()
	songListItem.song_name.text = song.song_name
	songListItem.artist_name.text = song.artist_name
	songListItem.play_button.connect("pressed", playFn.bind(song))
	return songListItem
