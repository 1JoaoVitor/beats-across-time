extends Node2D
class_name Player

@export var sprite: AnimatedSprite2D
@export var up: RayCast2D
@export var down: RayCast2D
@export var left: RayCast2D
@export var right: RayCast2D

var buffered_action: StringName

# TODO: move this constant to an apropriate place (like a tile map or GameManager)
# tem algum bug em relação ao player ter scale 3x?
const TILE_SIZE := Vector2(16, 16)*3
var sprite_tween: Tween

func _ready() -> void:
	Conductor.beat_hit.connect(_on_beat_hit)
	InputJudge.action_judged.connect(_on_action_judged)

func _on_beat_hit(beat: Conductor.BeatInfo, measure: int) -> void:
	if buffered_action == &"up" and not up.is_colliding():
		self._move(Vector2.UP)
	elif buffered_action == &"down" and not down.is_colliding():
		self._move(Vector2.DOWN)
	elif buffered_action == &"left" and not left.is_colliding():
		self._move(Vector2.LEFT)
	elif buffered_action == &"right" and not right.is_colliding():
		self._move(Vector2.RIGHT)
	buffered_action = &""

func _on_action_judged(action: StringName, judgment: InputJudge.Judgment, error_ms: int) -> void:
	if judgment == InputJudge.Judgment.HIT:
		buffered_action = action
	elif judgment == InputJudge.Judgment.MISS:
		pass

# Função antiga pro player se mover standalone, verificava tween
#func _physics_process(_delta: float) -> void:
	#if not sprite_tween or not sprite_tween.is_running():
		#if Input.is_action_just_pressed("up") and not up.is_colliding():
			#self._move(Vector2.UP)
		#elif Input.is_action_just_pressed("down") and not down.is_colliding():
			#self._move(Vector2.DOWN)
		#elif Input.is_action_just_pressed("left") and not left.is_colliding():
			#self._move(Vector2.LEFT)
		#elif Input.is_action_just_pressed("right") and not right.is_colliding():
			#self._move(Vector2.RIGHT)

func _move(direction: Vector2) -> void:
	self.global_position   += direction * TILE_SIZE
	sprite.global_position -= direction * TILE_SIZE
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property(sprite, "global_position", self.global_position, 0.15).set_trans(Tween.TRANS_SINE)
