extends Control

var database: SQLite
@onready var field_songName: TextEdit = $NameContainer/TextEdit
@onready var field_artistName: TextEdit = $ArtistContainer/TextEdit

func _ready():
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()

func create_database() -> void:
	var assets = DirAccess.open("res://assets")

	if assets:
		assets.list_dir_begin()
		var file_name = assets.get_next()
		while file_name != "":
			if assets.current_is_dir():
				print("Dir found: " + file_name)
			else:
				print("file found: " + file_name)
			assets.get_next()
	else:
		print("Failed to open directory")
	#var songs = {
		#"id": {"data_type": "int", "primary_key": true, "auto_increment": true, "not_null": true},
		#"song_name": {"data_type": "text"},
		#"artist_name": {"data_type": "text"}
	#}
	#database.create_table("songs", songs)

func _on_insert_data_pressed() -> void:
	if field_songName.text != "" && field_artistName.text != "":
		var data = {
			"song_name": field_songName.text,
			"artist_name": field_artistName.text
		}
		database.insert_row("songs", data)


func _on_select_data_pressed() -> void:
	print(database.select_rows("songs", "", ["*"]))


func _on_delete_data_pressed() -> void:
	create_database()
