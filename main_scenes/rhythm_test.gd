extends Node

@onready var label: Label = $Label
@onready var color_rect: ColorRect = $ColorRect

const GRAY = Color.DIM_GRAY
const GREEN = Color.DARK_GREEN
const RED = Color.DARK_RED

func _ready() -> void:
	Conductor.beat_hit.connect(_on_beat_hit)
	InputJudge.action_judged.connect(_on_action_judged)
	
	color_rect.color = GRAY
	
	var song_data = SongDB.get_song_data(SongDB.Song.TEST_SONG)
	Conductor.load_song(song_data)
	Conductor.start_song()


func _on_beat_hit(beat, measure_pos) -> void:
	label.text = "song_time = %.3f\nlast_beat.pos = %d\nmeasure_pos = %d" % [
	Conductor.song_time,
	beat.pos,
	measure_pos
]

func _on_action_judged(action: StringName, judgement: InputJudge.Judgment, error_ms: int) -> void:
	if action != &"space":
		return
		
	if judgement == InputJudge.Judgment.HIT:
		color_rect.color = GREEN
	else:
		color_rect.color = RED
	
	var tween = create_tween()
	tween.tween_property(color_rect, "color", GRAY, 0.5)
