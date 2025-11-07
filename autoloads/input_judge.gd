extends Node

## error_ms: Distance in miliseconds from target beat
signal action_judged(action: StringName, judgement: Judgment, error_ms: int)

enum Judgment {
	MISS,
	HIT
}

const HIT_WINDOW_EARLY_SEC: float = Settings.HIT_WINDOW_EARLY_SEC
const HIT_WINDOW_LATE_SEC: float = Settings.HIT_WINDOW_LATE_SEC

var _last_judged_beat_pos: int = -1


func _ready() -> void:
	Conductor.song_started.connect(_on_song_started)


func _on_song_started() -> void:
	_last_judged_beat_pos = -1

func _input(event: InputEvent) -> void:
	if not Conductor.playing:
		return
	
	var action_pressed: StringName
	
	if event.is_action_pressed("up"):
		action_pressed = &"up"
	elif event.is_action_pressed("down"):
		action_pressed = &"down"
	elif event.is_action_pressed("left"):
		action_pressed = &"left"
	elif event.is_action_pressed("right"):
		action_pressed = &"right"
	elif event.is_action_pressed("space"):
		action_pressed = &"space"
	else:
		return
	
	var input_time: float = Conductor.song_time
	
	# Finds the target beat
	var next_beat_distance = abs(input_time - Conductor.next_beat.time)
	var last_beat_distance = abs(input_time - Conductor.last_beat.time)
	var target_beat: Conductor.BeatInfo
	
	if next_beat_distance < last_beat_distance:
		target_beat = Conductor.next_beat
	else:
		target_beat = Conductor.last_beat
	
	if target_beat.pos == _last_judged_beat_pos:
		return # This prevents spam
	
	_last_judged_beat_pos = target_beat.pos
	
	var error_sec: float = input_time - target_beat.time
	
	if error_sec >= -HIT_WINDOW_EARLY_SEC and error_sec <= HIT_WINDOW_LATE_SEC:
		var error_ms = int(error_sec * 1000)
		self.action_judged.emit(action_pressed, Judgment.HIT, error_ms)
	else:
		var error_ms = int(error_sec * 1000)
		self.action_judged.emit(action_pressed, Judgment.MISS, error_ms)
