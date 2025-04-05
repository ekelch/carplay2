extends Control

var database: SQLite
var file_handles: Array
var state: AppState
@onready var song_list: VBoxContainer = $SongList
@onready var currently_playing: Label = $CurrentlyPlaying

func _ready():
	state = AppState.new()
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()
	create_database()
	refreshDatabase()

func refreshDatabase():
	populate_database_from_assets()
	cleanupDeletedSongs()
	generateSongRows()

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
				file_handles.append(file_name)
				database.query(insertSongQuery(file_name))
			file_name = dir.get_next()
	else:
		print("Failed to open directory")

func cleanupDeletedSongs():
	var db_file_handles = selectAllFilesSorted()
	for file in db_file_handles:
		if !file_handles.has(file):
			removeFile(file)

func insertSongQuery(file_name: String) -> String:
	var fstr = "INSERT OR IGNORE INTO songs(file_name, song_name) VALUES('%s','%s');"
	return fstr % [file_name, file_name]

func selectAllFilesSorted() -> Array:
	database.query("SELECT file_name FROM songs ORDER BY file_name ASC;")
	return database.query_result.map(func(e): return e.file_name)

func removeFile(file_name: String):
	database.delete_rows("songs", "file_name = '%s'" % file_name)

#Rerender songs list UI from all songs in database
func generateSongRows() -> void:
	var query_result = database.select_rows("songs", "", ["*"])
	
	for child in song_list.get_children(false):
		song_list.remove_child(child)
		
	for songDict in query_result:
		var song = SongModel.buildFromDict(songDict)
		song_list.add_child(SongListItem.buildSongListItem(song, play_song))

func play_song(song: SongModel):
	MusicPlayer.stop()
	state.song = song
	currently_playing.text = state.song.song_name
	
	var audio_stream = AudioStreamMP3.load_from_file("res://assets/" + song.file_name)
	MusicPlayer.stream = audio_stream
	MusicPlayer.play()

func _on_audio_stream_player_2d_finished() -> void:
	pass # Replace with function body.
