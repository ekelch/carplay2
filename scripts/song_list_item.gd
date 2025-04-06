class_name SongListItem extends Control
const songListScene = preload("res://scenes/song_list_item.tscn")
@export var song_name: Label
@export var artist_name: Label
@export var play_button: Button
@export var options_menu: MenuButton

static func buildSongListItem(song: SongModel, playFn: Callable) -> SongListItem:
	var songListItem: SongListItem = songListScene.instantiate()
	songListItem.song_name.text = song.song_name
	songListItem.artist_name.text = song.artist_name
	songListItem.play_button.connect("pressed", playFn.bind(song))
	songListItem.options_menu.get_popup().id_pressed.connect(func(id:int):_on_menu_item_pressed(id, song))
	return songListItem

static func _on_menu_item_pressed(id: int, song: SongModel):
	print(id)
	print(song.song_name)

static func deleteSelf():
	pass
