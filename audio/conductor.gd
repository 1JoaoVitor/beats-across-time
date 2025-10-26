extends AudioStreamPlayer

signal beat_hit(beat_pos: int, measure_pos: int)

var current_song: SongData = null
var bpm: int = 0 ## Beats per minute
var spb: float = 0.0 ## Seconds per beat (60 / bpm)
var measure: int = 4 ## Compasso
var initial_offset: float = 0.0

var song_time: float = 0.0
var song_beat_pos: int = 0
var last_beat_pos: int = -1
var measure_pos: int = 0


func _process(_delta: float) -> void:
	if not playing:
		return
	var time = self.get_playback_position()
	time += AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time -= initial_offset
	song_time = max(song_time, time)
	song_beat_pos = floori(song_time / spb)
	# Trigger beat
	if song_beat_pos > last_beat_pos:
		last_beat_pos = song_beat_pos
		measure_pos = 1 if measure_pos >= measure else measure_pos + 1
		self.beat_hit.emit(last_beat_pos, measure_pos)


func load_song(new_song: SongData) -> void:
	self.set_process(false)
	self.stop()
	
	# Set new properties
	current_song = new_song
	self.stream = new_song.audio_stream
	self.bpm = new_song.bpm
	self.spb = 60.0 / bpm
	self.measure = new_song.measures
	self.initial_offset = new_song.initial_offset


func start_song() -> void:
	# Reset properties
	song_time = 0.0
	song_beat_pos = 0
	last_beat_pos = -1
	measure_pos = 0
	
	self.set_process(true)
	self.play()
