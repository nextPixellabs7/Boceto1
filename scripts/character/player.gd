extends CharacterBody2D
# =========================
# SEÑALES
signal health_changed(current: int, maximum: int)
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
@export var max_health: int = 100
var health: int
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
	health = max_health
	health_changed.emit(health, max_health)
	_equipWeapon("sword")
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
		+ mouse_direction * _getAttackDistance())
	attack_pivot.global_rotation = mouse_direction.angle()

	# Temporizador del combo
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_step = 0

	# Cambiar arma (no mientras se ataca o esquiva)
	if not player_control.state_locked:
		if Input.is_action_just_pressed("weapon_sword"):
			_equipWeapon("sword")
		elif Input.is_action_just_pressed("weapon_dagger"):
			_equipWeapon("dagger")
		elif Input.is_action_just_pressed("weapon_axe"):
			_equipWeapon("axe")
# =========================
# EQUIPAR ARMA
func _equipWeapon(weapon_name: String) -> void:
	current_weapon = weapon_name
	for key in weapons:
		weapons[key].visible = (key == weapon_name)
	combo_step = 0
	combo_timer = 0
	weapon_changed.emit(weapon_name)
# =========================
# DISTANCIA DEL ATAQUE
func _getAttackDistance() -> float:
	return weapons[current_weapon].attack_distance
# =========================
# RECIBIR DAÑO
func _takedamage(damage: int) -> void:
	if is_dodging:
		print("DODGE - DAÑO EVITADO")
		return
	health = max(health - damage, 0)
	health_changed.emit(health, max_health)
	print("PLAYER RECIBIÓ DAÑO: ", damage, " | VIDA: ", health)
	if health <= 0:
		_die()
# =========================
# MUERTE
func _die() -> void:
	print("PLAYER MUERTO")
	set_physics_process(false)
