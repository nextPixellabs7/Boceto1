extends Node
# =========================
# REFERENCIAS
@onready var player = owner
@onready var control = get_parent()
# =========================
# DATOS DEL DODGE
@export var dodge_speed: float = 600.0
@export var dodge_duration: float = 0.2
@export var dodge_cooldown: float = 0.8

var can_dodge: bool = true
var _dodge_direction: Vector2 = Vector2.ZERO
var _time_left: float = 0.0
# =========================
# COMPROBAR SI PUEDE ENTRAR
func _can_enter(direction: Vector2) -> bool:
	if not can_dodge:
		return false
	if direction.is_zero_approx():
		return false
	return Input.is_action_just_pressed("dodge")
# =========================
# ENTRAR AL ESTADO
func _enter() -> void:
	can_dodge = false
	control.state_locked = true
	player.is_dodging = true
	_dodge_direction = control._get_movement_direction().normalized()
	_time_left = dodge_duration
# =========================
# SALIR DEL ESTADO
func _exit() -> void:
	player.is_dodging = false
# =========================
# ACTUALIZAR
func _physics_update(_direction: Vector2, delta: float) -> void:
	player.velocity = _dodge_direction * dodge_speed
	_time_left -= delta
	if _time_left <= 0.0:
		control._unlock()
		_start_cooldown()
# =========================
# COOLDOWN (corre aparte, no bloquea al jugador)
func _start_cooldown() -> void:
	await get_tree().create_timer(dodge_cooldown).timeout
	can_dodge = true
