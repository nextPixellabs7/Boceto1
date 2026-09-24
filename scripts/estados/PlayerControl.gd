extends Node

@onready var idle = $Idle
@onready var move = $Move
@onready var attack = $Attack
@onready var dodge = $Dodge

# =========================
# ESTADOS

enum PlayerState {
	IDLE,
	MOVE,
	ATTACK,
	DODGE
}

var current_state: PlayerState = PlayerState.IDLE
var state_locked: bool = false

func _ready():

	print("Idle: ", idle)
	print("Move: ", move)
	print("Attack: ", attack)
# =========================
# MOVIMIENTO

func _getMovementDirection() -> Vector2:

	var direction: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	return direction


# =========================
# ACTUALIZAR ESTADO

func _updateState(direction: Vector2):

	if state_locked:
		return

	if dodge._canEnter(direction):
		_changeState(PlayerState.DODGE)
		return

	if attack._canEnter():
		_changeState(PlayerState.ATTACK)
		return

	if idle._canEnter(direction):
		_changeState(PlayerState.IDLE)
	elif move._canEnter(direction):
		_changeState(PlayerState.MOVE)


# =========================
# CAMBIAR ESTADO

func _changeState(new_state: PlayerState):

	if current_state == new_state:
		return

	current_state = new_state

	print("Estado: ", current_state)


# =========================
# COMPROBAR ATAQUE
func _isAttacking() -> bool:
	return current_state == PlayerState.ATTACK
# =========================
# TERMINAR ATAQUE
func _finishAttack(direction: Vector2):
	state_locked = false
	if direction == Vector2.ZERO:
		_changeState(PlayerState.IDLE)
	else:
		_changeState(PlayerState.MOVE)
