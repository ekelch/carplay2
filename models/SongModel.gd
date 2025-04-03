class_name SongModel extends Object

var song_name: String
var file_name: String
var artist_name: String
var genre_name: String

func setSong(songDict: Dictionary):
	song_name = songDict.get("song_name")
	file_name = songDict.get("file_name")
	artist_name = songDict.get("artist_name")
	genre_name = songDict.get("genre_name")

static func buildFromDict(songDict: Dictionary) -> SongModel:
	var this = SongModel.new()
	this.song_name = songDict.get("song_name")
	this.file_name = songDict.get("file_name")
	this.artist_name = songDict.get("artist_name", "")
	this.genre_name = songDict.get("genre_name", "")
	return this
