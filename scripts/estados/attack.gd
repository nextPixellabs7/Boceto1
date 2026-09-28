extends State

# =========================
# DATOS DEL ATAQUE

var can_attack: bool = true

var _weapon: Node2D
var _frames: int = 0
var _time_left: float = 0.0
var _finished: bool = false

# =========================
# COMPROBAR SI PUEDE ENTRAR

func _can_enter() -> bool:
	return can_attack and Input.is_action_just_pressed("attack")

# =========================
# ENTRAR AL ESTADO

func _enter() -> void:
	_weapon = player.weapons[player.current_weapon]
	_finished = false
	can_attack = false
	control.state_locked = true
	player.combo_timer = 0.0

	# Avanzar combo
	player.combo_step += 1
	if player.combo_step > _weapon.max_combo:
		player.combo_step = 1

	print(player.current_weapon, " - golpe ", player.combo_step)

	# Activar hitbox
	_frames = 0
	_time_left = _weapon.attack_delay
	_weapon.hitbox.monitoring = true

# =========================
# SALIR DEL ESTADO

func _exit() -> void:
	if _weapon:
		_weapon.hitbox.monitoring = false

	# Si nos interrumpieron a mitad de golpe (por ejemplo, Hurt),
	# reiniciar el combo y permitir atacar de nuevo
	if not _finished:
		player.combo_step = 0
		can_attack = true

# =========================
# ACTUALIZAR

func _physics_update(_direction: Vector2, delta: float) -> void:
	player.velocity = Vector2.ZERO
	_frames += 1

	# El Area2D necesita un par de frames físicos para detectar cuerpos
	if _frames == 2:
		_apply_damage()

	_time_left -= delta
	if _time_left <= 0.0:
		_finish()

# =========================
# HACER DAÑO

func _apply_damage() -> void:
	var bodies = _weapon.hitbox.get_overlapping_bodies()
	print("Cuerpos detectados: ", bodies.size())

	for body in bodies:
		if body.has_method("_take_damage"):
			body._take_damage(_weapon.damage, player.global_position)

	_weapon.hitbox.monitoring = false

# =========================
# TERMINAR GOLPE

func _finish() -> void:
	var was_last_hit: bool = player.combo_step == _weapon.max_combo
	var cooldown: float = _weapon.cooldown

	_finished = true
	control._unlock()

	if was_last_hit:
		print("FIN DEL COMBO")
		player.combo_step = 0
		_start_cooldown(cooldown)
	else:
		player.combo_timer = player.combo_time
		can_attack = true

# =========================
# COOLDOWN (corre aparte, no bloquea al jugador)

func _start_cooldown(time: float) -> void:
	await get_tree().create_timer(time).timeout
	can_attack = true
