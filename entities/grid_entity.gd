@abstract
class_name GridEntity
extends Node2D

### Sinal disparado quando o movimento visual (Tween) termina
#signal movement_finished

## A posição lógica na matriz. 
var grid_pos: Vector2i
var grid: GridSystem
@export var is_hittable: bool = false
@export var occupies_tile: bool = false
@export var is_immobile: bool = false

### Referência opcional para animar algo específico (ex: o Sprite dentro do Player)
### Se não for atribuído, moveremos o próprio root do objeto.
#@export var visual_node: Node2D


func _ready() -> void:
	grid = GameManager.active_grid
	assert(grid != null, "Error: GameManager.active_grid == null")
	# Ao nascer, a entidade tenta descobrir onde ela está no grid baseado na posição do editor
	grid_pos = grid.local_to_map(self.global_position)
	# Corrige imprecisão centralizando no tile
	self.global_position = grid.map_to_local(grid_pos)
	# Registra sua posição atual no grid system
	grid.register_entity(self, grid_pos)


## Função para mover a entidade logicamente e visualmente
## Moves the entity logically and visually
## Does not check
func move_to(target_grid_pos: Vector2i) -> void:
	if is_immobile:
		return
	# 1. Atualiza o registro no GridSystem (libera o tile antigo, ocupa o novo)
	if not grid.move_entity(self, grid_pos, target_grid_pos):
		return # Não foi possível mover a entidade
	
	# 2. Atualiza a variável lógica
	grid_pos = target_grid_pos
	
	# 3. Calcula a posição no mundo real para onde vamos
	var target_world_pos: Vector2 = grid.map_to_local(target_grid_pos)

	# 4. Inicia o movimento visual (Tween)
	var tween = create_tween()
	# Usar ease_out deixa o movimento mais "snappy" (rápido no começo, suave no fim)
	tween.tween_property(self, "global_position", target_world_pos, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#tween.tween_callback(func(): movement_finished.emit())

### Interface de Dano (Polimorfismo)
#@abstract
#func take_damage(_amount: int) -> void
