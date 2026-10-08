extends CharacterBody2D

# =========================
# SEÑALES
signal weapon_changed(weapon_name: String)

# =========================
# MOVIMIENTO
@export var speed: float = 200.0

# =========================
# NODOS
@onready var attack_pivot: Node2D = $AttackHitbox
@onready var player_control: Node = $PlayerControl
@onready var health: Health = $Health

# =========================
# ARMAS
@onready var weapons := {
	"sword": $AttackHitbox/Sword,
	"dagger": $AttackHitbox/Dagger,
	"axe": $AttackHitbox/Axe,
}
var current_weapon: String = "sword"

# =========================
# COMBOS
var combo_step: int = 0
var combo_timer: float = 0.0
@export var combo_time: float = 0.8

# =========================
# DODGE
var is_dodging: bool = false

# =========================
# INICIO
func _ready() -> void:
	add_to_group("player")
	health.died.connect(_on_died)
	_equip_weapon("sword")

# =========================
# FÍSICA
func _physics_process(delta: float) -> void:
	# 1. Estado y movimiento (PlayerControl calcula velocity)
	player_control._physics_update(delta)
	move_and_slide()

	# 2. Orientación del ataque hacia el ratón
	var mouse_pos := get_global_mouse_position()
	if global_position.distance_squared_to(mouse_pos) > 1.0:
		var mouse_direction := global_position.direction_to(mouse_pos)
		attack_pivot.global_position = global_position + (mouse_direction * _get_attack_distance())
		attack_pivot.global_rotation = mouse_direction.angle()

	# 3. Temporizador de combo
	if combo_timer > 0.0:
		combo_timer -= delta
		if combo_timer <= 0.0:
			combo_step = 0

	# 4. Cambio de arma (bloqueado durante ataques/dodge)
	if not player_control.state_locked:
		_handle_weapon_inputs()

# =========================
# GESTIÓN DE ARMAS
func _handle_weapon_inputs() -> void:
	for weapon_name in weapons.keys():
		if Input.is_action_just_pressed("weapon_" + weapon_name):
			if current_weapon != weapon_name:
				_equip_weapon(weapon_name)
			break

func _equip_weapon(weapon_name: String) -> void:
	if not weapons.has(weapon_name):
		return

	current_weapon = weapon_name
	for key in weapons:
		weapons[key].visible = (key == weapon_name)

	combo_step = 0
	combo_timer = 0.0
	weapon_changed.emit(weapon_name)

func _get_attack_distance() -> float:
	return weapons[current_weapon].attack_distance

# =========================
# RECIBIR DAÑO
func _take_damage(damage: int, source_position: Vector2 = Vector2.INF) -> void:
	var state = player_control.current_state
	var states = player_control.PlayerState

	# Inmunidad durante dodge, herido (i-frames) o muerto
	if is_dodging or state == states.HURT or state == states.DEAD:
		return

	# Llama al método del componente (compatible con ambas versiones)
	if health.has_method("take_damage"):
		health.take_damage(damage)
	elif health.has_method("_takedamage"):
		health._takedamage(damage)

	print("PLAYER RECIBIÓ DAÑO: ", damage, " | VIDA: ", health.current)

	if health.current == 0:
		return  # _on_died se encarga del cambio a DEAD

	player_control.hurt._set_knockback(source_position)
	player_control._change_state(states.HURT)

# =========================
# MUERTE
func _on_died() -> void:
	player_control._change_state(player_control.PlayerState.DEAD)
