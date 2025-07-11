class_name SongListItem extends Control
@export var song_name: Label
@export var artist_name: Label
@export var play_button: Button
@export var options_menu: MenuButton
var song: SongModel
@onready var changes_container: HBoxContainer = $Hbox/ChangesContainer
@onready var changes_text: TextEdit = $Hbox/ChangesContainer/ChangesText

func buildSongListItem(songModel: SongModel):
	song = songModel
	song_name.text = song.song_name
	artist_name.text = song.artist_name
	play_button.connect("pressed", MusicPlayer.loadSong.bind(song))
	options_menu.get_popup().id_pressed.connect(_on_menu_item_pressed)

func _on_menu_item_pressed(id: int):
	match id:
		0: editSongName()
		1: editArtistName()
		2: deleteSelf()

func editSongName():
	print("editing song name " + song.song_name)
	showSongEdit(true)
	
func showSongEdit(showEdit: bool):
	options_menu.visible = !showEdit
	changes_container.visible = showEdit
	
func editArtistName():
	print("editing artist name " + song.artist_name)

func deleteSelf():
	queue_free()

func _on_edit_cancel_pressed() -> void:
	showSongEdit(false)

func _on_edit_confirm_pressed() -> void:
	SqlController.renameDisplayName(song, changes_text.text)
	song_name.text = changes_text.text
	showSongEdit(false)
