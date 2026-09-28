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
@onready var player_control = $PlayerControl
# =========================
# ARMAS
@onready var weapons := {
	"sword": $AttackHitbox/Sword,
	"dagger": $AttackHitbox/Dagger,
	"axe": $AttackHitbox/Axe,
}
var current_weapon: String = "sword"
# =========================
# VIDA
@onready var health: Health = $Health
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
	health.changed.emit(health.current, health.max_health)
	_equip_weapon("sword")
# =========================
# FÍSICA
func _physics_process(delta: float) -> void:
	# Estado actual (movimiento, ataque, dodge)
	player_control._physics_update(delta)
	move_and_slide()
	# Dirección del ataque
	var mouse_direction := global_position.direction_to(
		get_global_mouse_position())
	attack_pivot.global_position = (
		global_position
		+ mouse_direction * _get_attack_distance())
	attack_pivot.global_rotation = mouse_direction.angle()

	# Temporizador del combo
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_step = 0

	# Cambiar arma (no mientras se ataca o esquiva)
	if not player_control.state_locked:
		if Input.is_action_just_pressed("weapon_sword"):
			_equip_weapon("sword")
		elif Input.is_action_just_pressed("weapon_dagger"):
			_equip_weapon("dagger")
		elif Input.is_action_just_pressed("weapon_axe"):
			_equip_weapon("axe")
# =========================
# EQUIPAR ARMA
func _equip_weapon(weapon_name: String) -> void:
	current_weapon = weapon_name
	for key in weapons:
		weapons[key].visible = (key == weapon_name)
	combo_step = 0
	combo_timer = 0
	weapon_changed.emit(weapon_name)
# ========================
# DISTANCIA DEL ATAQUE
func _get_attack_distance() -> float:
	return weapons[current_weapon].attack_distance
# =========================
# RECIBIR DAÑO
func _take_damage(damage: int, source_position: Vector2 = Vector2.INF) -> void:
	var state = player_control.current_state
	var states = player_control.PlayerState

	# Sin daño durante dodge, herido (frames de invulnerabilidad) o muerto
	if is_dodging or state == states.HURT or state == states.DEAD:
		return

	health._takedamage(damage)
	print("PLAYER RECIBIÓ DAÑO: ", damage, " | VIDA: ", health.current)

	if health.current == 0:
		return  # _on_died se encarga

	player_control.hurt._set_knockback(source_position)
	player_control._change_state(states.HURT)
# =========================
# MUERTE
func _on_died() -> void:
	player_control._change_state(player_control.PlayerState.DEAD)
