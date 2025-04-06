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
	match id:
		0: editSongName()
		1: editArtistName()
		2: deleteSelf()

func editSongName():
	print("editing song name " + song.song_name)
	
func editArtistName():
	print("editing artist name " + song.artist_name)

func deleteSelf():
	queue_free()
