extends CharacterBody2D

@export var speed: float = 200.0
@onready var attack_pivot: Node2D = $AttackHitbox
@onready var sword = $AttackHitbox/Sword
@onready var dagger = $AttackHitbox/Dagger
@onready var axe = $AttackHitbox/Axe
@onready var player_control = $PlayerControl

var attack_hitbox: Area2D

# =========================
# VIDA
@export var max_health: int = 100
var health: int
# =========================
# ARMAS
var current_weapon: String = "sword"

# =========================
# COMBOS
var combo_step: int = 0
var combo_timer: float = 0.0
var can_attack: bool = true

@export var combo_time: float = 0.8
# =========================
# DODGE
var is_dodging: bool = false
#==========================
func _ready():
	health = max_health
	
	sword.visible = true
	dagger.visible = false
	axe.visible = false
	_updateAttackHitbox()
	
func _physics_process(delta: float) -> void:
	# =========================
	# MOVIMIENTO
	var direction: Vector2 = player_control._getMovementDirection()
	player_control._updateState(direction)
	if player_control._isAttacking():
		velocity = Vector2.ZERO
	else:
		if not is_dodging:
			velocity = direction * speed
	move_and_slide()
	# =========================
	# DIRECCIÓN DEL ATAQUE
	var mouse_direction := global_position.direction_to(
		get_global_mouse_position())
	attack_pivot.global_position = (
		global_position
		+ mouse_direction * _getAttackDistance())
	attack_pivot.global_rotation = mouse_direction.angle()

	# =========================
	# TEMPORIZADOR DEL COMBO
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_step = 0

	# =========================
	# CAMBIAR ARMA
	if Input.is_action_just_pressed("weapon_sword"):
		current_weapon = "sword"
		sword.visible = true
		dagger.visible = false
		axe.visible = false
		combo_step = 0
		combo_timer = 0
		_updateAttackHitbox()
		print("Espada larga equipada")

	if Input.is_action_just_pressed("weapon_dagger"):
		current_weapon = "dagger"
		sword.visible = false
		dagger.visible = true
		axe.visible = false
		combo_step = 0
		combo_timer = 0
		_updateAttackHitbox()
		print("Daga equipada")

	if Input.is_action_just_pressed("weapon_axe"):
		current_weapon = "axe"
		sword.visible = false
		dagger.visible = false
		axe.visible = true
		combo_step = 0
		combo_timer = 0
		_updateAttackHitbox()
		print("Gran hacha equipada")

	# =========================
	# ATAQUE
	if player_control._isAttacking() and can_attack and not is_dodging:
		player_control.state_locked = true
		await player_control.attack._execute()
		player_control._finishAttack(direction)
	# =========================
	# DODGE
	if player_control.current_state == player_control.PlayerState.DODGE and not is_dodging and player_control.dodge.can_dodge:
		player_control.state_locked = true
		await player_control.dodge._execute(direction)
		player_control._finishAttack(direction)
# =========================
# DISTANCIA DEL ATAQUE
func _getAttackDistance() -> float:
	match current_weapon:
		"sword":
			return sword.attack_distance
		"dagger":
			return dagger.attack_distance
		"axe":
			return axe.attack_distance
	return 50.0

# =========================
# TAMAÑO DEL HITBOX
func _updateAttackHitbox():
	match current_weapon:
		"sword":
			attack_hitbox = sword.hitbox
		"dagger":
			attack_hitbox = dagger.hitbox
		"axe":
			attack_hitbox = axe.hitbox

# =========================
# RECIBIR DAÑO
func _takedamage(damage: int):
	if is_dodging:
		print("DODGE - DAÑO EVITADO")
		return
	health -= damage
	print("PLAYER RECIBIÓ DAÑO: ", damage)
	print("VIDA RESTANTE: ", health)
	if health <= 0:
		_die()
# =========================
# MUERTE
func _die():
	print("PLAYER MUERTO")
	set_physics_process(false)
