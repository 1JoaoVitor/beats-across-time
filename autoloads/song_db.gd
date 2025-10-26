extends Node

enum Song {
	TEST_SONG,
}

const SONGS_UIDS: Dictionary = {
	Song.TEST_SONG: "uid://bkvw7rghnut5a",
}

func get_song_data(song: Song) -> SongData:
	return load(SONGS_UIDS[song])
