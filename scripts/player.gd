extends CharacterBody2D

@export var speed: float = 200.0
@onready var attack_pivot: Node2D = $AttackHitbox
@onready var sword = $AttackHitbox/Sword
@onready var dagger = $AttackHitbox/Dagger
@onready var axe = $AttackHitbox/Axe

var attack_hitbox: Area2D

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
@export var dodge_speed: float = 600.0
@export var dodge_duration: float = 0.2
@export var dodge_cooldown: float = 0.8

var is_dodging: bool = false
var can_dodge: bool = true
#==========================
func _ready():
	sword.visible = true
	dagger.visible = false
	axe.visible = false
	_updateAttackHitbox()
	
func _physics_process(delta: float) -> void:
	# =========================
	# MOVIMIENTO
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	if not is_dodging:
		velocity = direction * speed
	move_and_slide()
	# =========================
	# DODGE
	if Input.is_action_just_pressed("dodge") and can_dodge and not is_dodging:
		_dodge(direction)
		
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
	if Input.is_action_just_pressed("attack") and can_attack and not is_dodging:
		_attack()

func _attack():
	can_attack = false
	var damage = 0
	var max_combo = 1
	var attack_delay = 0.15
	var cooldown = 0.5

	# =========================
	# CONFIGURAR ARMA
	match current_weapon:
		"sword":
			damage = sword.damage
			max_combo = sword.max_combo
			attack_delay = sword.attack_delay
			cooldown = sword.cooldown
		"dagger":
			damage = dagger.damage
			max_combo = dagger.max_combo
			attack_delay = dagger.attack_delay
			cooldown = dagger.cooldown
		"axe":
			damage = axe.damage
			max_combo = axe.max_combo
			attack_delay = axe.attack_delay
			cooldown = axe.cooldown
	# =========================
	# AVANZAR COMBO
	combo_step += 1
	if combo_step > max_combo:
		combo_step = 1
	print(current_weapon, " - golpe ", combo_step)

	# =========================
	# ACTIVAR HITBOX
	attack_hitbox.monitoring = true
	await get_tree().physics_frame
	var bodies = attack_hitbox.get_overlapping_bodies()
	print("Cuerpos detectados: ", bodies.size())

	# =========================
	# HACER DAÑO
	for body in bodies:
		print("Detectado: ", body.name)
		if body.has_method("_takedamage"):
			body._takedamage(damage)

	# =========================
	# DESACTIVAR HITBOX
	attack_hitbox.monitoring = false

	# =========================
	# ESPERA ENTRE GOLPES
	await get_tree().create_timer(attack_delay).timeout

	# =========================
	# FIN DEL COMBO
	if combo_step == max_combo:
		print("FIN DEL COMBO")
		await get_tree().create_timer(cooldown).timeout
		combo_step = 0
		combo_timer = 0
	else:
		combo_timer = combo_time
	can_attack = true

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
# DODGE
func _dodge(direction: Vector2):
	if direction == Vector2.ZERO:
		return
	is_dodging = true
	can_dodge = false
	var dodge_direction = direction.normalized()
	velocity = dodge_direction * dodge_speed
	await get_tree().create_timer(dodge_duration).timeout
	velocity = Vector2.ZERO
	is_dodging = false
	await get_tree().create_timer(dodge_cooldown).timeout
	can_dodge = true
