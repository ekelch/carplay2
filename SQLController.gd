extends Control

var database: SQLite
@onready var field_songName: TextEdit = $NameContainer/TextEdit
@onready var field_artistName: TextEdit = $ArtistContainer/TextEdit
@onready var song_list: VBoxContainer = $SongList
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()

func create_database() -> void:
	var songs = {
		"id": {"data_type": "int", "primary_key": true, "auto_increment": true, "not_null": true},
		"file_name": {"data_type": "text", "unique": true},
		"song_name": {"data_type": "text"},
		"artist_id": {"data_type": "int"},
		"genre_id": {"data_type": "int"}
	}
	database.create_table("songs", songs)
	
func populate_database_from_assets():
	var dir = DirAccess.open("res://assets")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() && file_name.ends_with(".mp3"):
				var data = {
					"file_name": file_name,
					"song_name": file_name,
					"artist_id": null,
					"genre_id": null
				}
				database.query(insertSongQuery(file_name))
			file_name = dir.get_next()
	else:
		print("Failed to open directory")

func insertSongQuery(file_name: String) -> String:
	var fstr = "INSERT OR IGNORE INTO songs(file_name, song_name) VALUES('%s','%s')"
	return fstr % [file_name, file_name]

func _on_insert_data_pressed() -> void:
	create_database()
	populate_database_from_assets()

func _on_select_data_pressed() -> void:
	var query_result = database.select_rows("songs", "", ["*"])
	
	for child in song_list.get_children(false):
		song_list.remove_child(child)
		
	for song in query_result:
		var hbox = HBoxContainer.new()
		var button = Button.new()
		button.text = "play"
		print(song)
		print(song.file_name)
		button.pressed.connect(play_song.bind(song.file_name))
		var label = Label.new()
		label.text = song.song_name
		hbox.add_child(button)
		hbox.add_child(label)
		song_list.add_child(hbox)

func play_song(file_name: String):
	audio_stream_player.stop()
	var audio_stream = AudioStreamMP3.load_from_file("res://assets/" + file_name)
	audio_stream_player.stream = audio_stream
	audio_stream_player.play()

func _on_delete_data_pressed() -> void:
	pass
