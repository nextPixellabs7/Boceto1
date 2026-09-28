extends Node
# =========================
# ESTADOS
enum PlayerState {IDLE,MOVE,ATTACK,DODGE,HURT,DEAD}
@onready var states := {
	PlayerState.IDLE: $Idle,
	PlayerState.MOVE: $Move,
	PlayerState.ATTACK: $Attack,
	PlayerState.DODGE: $Dodge,
	PlayerState.HURT: $Hurt,
	PlayerState.DEAD: $Dead,
}
@onready var hurt = $Hurt
var current_state: PlayerState = PlayerState.IDLE
var state_locked: bool = false
# =========================
# MOVIMIENTO
func _get_movement_direction() -> Vector2:
	return Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
# =========================
# ACTUALIZAR (se llama cada frame desde el Player)
func _physics_update(delta: float) -> void:
	var direction := _get_movement_direction()
	if not state_locked:
		_choose_state(direction)
	states[current_state]._physics_update(direction, delta)
# =========================
# ELEGIR ESTADO
func _choose_state(direction: Vector2) -> void:
	if states[PlayerState.DODGE]._can_enter(direction):
		_change_state(PlayerState.DODGE)
	elif states[PlayerState.ATTACK]._can_enter():
		_change_state(PlayerState.ATTACK)
	elif direction.is_zero_approx():
		_change_state(PlayerState.IDLE)
	else:
		_change_state(PlayerState.MOVE)
# =========================
# CAMBIAR ESTADO
func _change_state(new_state: PlayerState) -> void:
	if new_state == current_state:
		return
	states[current_state]._exit()
	current_state = new_state
	states[current_state]._enter()
# =========================
# DESBLOQUEAR (lo llaman Attack y Dodge al terminar)
func _unlock() -> void:
	state_locked = false
	_change_state(PlayerState.IDLE)
