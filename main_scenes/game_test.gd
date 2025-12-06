extends Node2D

@onready var song_time_label: Label = $VBoxContainer/SongTimeLabel
@onready var label: Label = $VBoxContainer/Label
@onready var color_rect: ColorRect = $ColorRect
@onready var error_label: Label = $VBoxContainer/ErrorLabel

const GRAY = Color.DIM_GRAY
const GREEN = Color.DARK_GREEN
const RED = Color.DARK_RED

func _ready() -> void:
	Conductor.beat_hit.connect(_on_beat_hit)
	InputJudge.action_judged.connect(_on_action_judged)
	
	color_rect.color = Color(GRAY, 0)
	
	var song_data = SongDB.get_song_data(SongDB.Song.TEST_SONG)
	Conductor.load_song(song_data)
	Conductor.start_song()

func _process(delta: float) -> void:
	song_time_label.text = "song_time = %.3f" % Conductor.song_time

func _on_beat_hit(beat: Conductor.BeatInfo, measure_pos) -> void:
	label.text = "turn time = %.3f\nlast_beat.pos = %d\nmeasure_pos = %d" % [
	Conductor.song_time,
	beat.pos,
	measure_pos
]

func _on_action_judged(action: StringName, judgement: InputJudge.Judgment, error_ms: int) -> void:
	if action == &"up" or action == &"down" or action == &"left" or action == &"right" or action == &"space":
		if judgement == InputJudge.Judgment.HIT:
			color_rect.color = Color(GREEN, 1)
		else:
			color_rect.color = Color(RED, 1)
		error_label.text = "error_ms = %d" % error_ms
		
		var tween = create_tween()
		tween.tween_property(color_rect, "color", Color(GRAY, 0), 0.5)
