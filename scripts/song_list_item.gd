class_name SongListItem extends Control
@export var song_name: Label
@export var artist_name: Label
@export var play_button: Button
@export var options_menu: MenuButton
var song: SongModel
@onready var changes_container: HBoxContainer = $Hbox/ChangesContainer
@onready var changes_text: TextEdit = $Hbox/ChangesContainer/ChangesText

enum EDITING {
	NONE,
	SONG_NAME,
	ARTIST_NAME,
}
signal edit_state_changed
var edit_state = EDITING.NONE

func buildSongListItem(songModel: SongModel):
	song = songModel
	song_name.text = song.song_name
	artist_name.text = song.artist_name
	play_button.connect("pressed", MusicPlayer.loadSong.bind(song))
	options_menu.get_popup().id_pressed.connect(_on_menu_item_pressed)

func handleEditStateChange(editState: EDITING):
	match editState:
		EDITING.NONE: showTextEditor(false)
		EDITING.SONG_NAME: showTextEditor(true)
		EDITING.ARTIST_NAME: showTextEditor(true)

func _ready() -> void:
	edit_state_changed.connect(handleEditStateChange)

func setEditing(state: EDITING):
	edit_state_changed.emit(state)
	edit_state = state

func _on_menu_item_pressed(id: int):
	match id:
		0: setEditing(EDITING.SONG_NAME)
		1: setEditing(EDITING.ARTIST_NAME)
		2: queue_free()
	
func showTextEditor(showEdit: bool):
	options_menu.visible = !showEdit
	changes_container.visible = showEdit	

func _on_edit_cancel_pressed() -> void:
	setEditing(EDITING.NONE)

func _on_edit_confirm_pressed() -> void:
	if (edit_state == EDITING.SONG_NAME):
		SqlController.renameDisplayName(song, changes_text.text)
		song_name.text = changes_text.text
	elif (edit_state == EDITING.ARTIST_NAME):
		SqlController.renameArtist(song, changes_text.text)
		artist_name.text = changes_text.text
	changes_text.text = ""
	setEditing(EDITING.NONE)
