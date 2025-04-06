extends Node
var database: SQLite
var file_handles: Array

func _ready():
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()
	create_database()
	refreshDatabase()

func refreshDatabase():
	populate_database_from_assets()
	cleanupDeletedSongs()

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
	var dir = DirAccess.open("res://assets/songs")
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

func getAllSongs():
	return database.select_rows("songs", "", ["*"])
