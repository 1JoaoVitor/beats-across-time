extends Node

@onready var label: Label = $Label
@onready var color_rect: ColorRect = $ColorRect

const GRAY = Color.DIM_GRAY
#const GREEN = Color(0.1, 0.4, 0.1)
const GREEN = Color.DARK_GREEN
#const RED = Color(0.4, 0.1, 0.1)
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
	# Ignora se a ação não foi a que queremos testar (Espaço)
	if action != &"space":
		return
		
	# 1. Define a cor com base no julgamento
	if judgement == InputJudge.Judgment.HIT:
		color_rect.color = GREEN
	else: # Deve ser MISS
		color_rect.color = RED
	
	# 2. Cria um "flash" para a cor voltar ao preto
	# Isso faz a cor sumir suavemente em 0.3 segundos.
	var tween = create_tween()
	tween.tween_property(color_rect, "color", GRAY, 0.5)
