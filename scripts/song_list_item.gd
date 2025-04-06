class_name SongListItem extends Control
@export var song_name: Label
@export var artist_name: Label
@export var play_button: Button
@export var options_menu: MenuButton
var song: SongModel

func buildSongListItem(songModel: SongModel, playFn: Callable):
	song = songModel
	song_name.text = song.song_name
	artist_name.text = song.artist_name
	play_button.connect("pressed", playFn.bind(song))
	options_menu.get_popup().id_pressed.connect(_on_menu_item_pressed)

func _on_menu_item_pressed(id: int):
	print(id)
	print(song.song_name)

static func deleteSelf():
	pass
