extends State

# =========================
# DATOS
@export var hurt_duration: float = 0.25
@export var knockback_speed: float = 300.0

var _knockback_direction: Vector2 = Vector2.ZERO
var _time_left: float = 0.0
# =========================
# CONFIGURAR EMPUJE
func _set_knockback(from_position: Vector2) -> void:
	if from_position.is_finite():
		_knockback_direction = from_position.direction_to(player.global_position)
	else:
		_knockback_direction = Vector2.ZERO
# =========================
# ENTRAR AL ESTADO
func _enter() -> void:
	control.state_locked = true
	_time_left = hurt_duration
# =========================
# ACTUALIZAR
func _physics_update(_direction: Vector2, delta: float) -> void:
	# El empuje se va apagando poco a poco
	var strength := _time_left / hurt_duration
	player.velocity = _knockback_direction * knockback_speed * strength
	_time_left -= delta
	if _time_left <= 0.0:
		control._unlock()
