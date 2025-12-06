extends GridEntity
class_name Player

@export var sprite: AnimatedSprite2D

#const ACTIONS: Dictionary[StringName, Dictionary] = {
	#&"up": { "vector": Vector2i.UP, "collider": up },
#}
const ACTIONS_VECTOR: Dictionary[StringName, Vector2i] = {
	&"up":    Vector2i.UP,
	&"down":  Vector2i.DOWN,
	&"left":  Vector2i.LEFT,
	&"right": Vector2i.RIGHT,
}

var buffered_action: StringName


# TODO: move this constant to an apropriate place (like a tile map or GameManager)
# tem algum bug em relação ao player ter scale 3x?
const TILE_SIZE := Vector2(16, 16)*3
var sprite_tween: Tween

func _ready() -> void:
	super()
	Conductor.beat_hit.connect(_on_beat_hit)
	InputJudge.action_judged.connect(_on_action_judged)

func _on_beat_hit(beat: Conductor.BeatInfo, measure: int) -> void:
	if buffered_action in ACTIONS_VECTOR:
		var target_grid_pos: Vector2i = self.grid_pos + ACTIONS_VECTOR[buffered_action]
		if grid.is_tile_walkable(target_grid_pos) and not grid.is_tile_occupied(target_grid_pos):
			self.move_to(target_grid_pos)
			# DEBUG TEMPORARIO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			print("global position: " + str(self.global_position))
	buffered_action = &""


func _on_action_judged(action: StringName, judgment: InputJudge.Judgment, error_ms: int) -> void:
	if judgment == InputJudge.Judgment.HIT:
		buffered_action = action
	elif judgment == InputJudge.Judgment.MISS:
		pass
