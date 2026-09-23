extends CharacterBody2D

@export var speed: float = 200.0
@onready var attack_pivot: Node2D = $AttackHitbox
@onready var sword = $AttackHitbox/Sword
@onready var dagger = $AttackHitbox/Dagger
@onready var axe = $AttackHitbox/Axe

var attack_hitbox: Area2D
var attack_shape: CollisionShape2D

# =========================
# ARMAS
var current_weapon: String = "sword"

var dagger_damage: int = 10
var axe_damage: int = 40

# Distancia de cada arma

var dagger_distance: float = 35.0
var axe_distance: float = 70.0

# =========================
# COMBOS
var combo_step: int = 0
var combo_timer: float = 0.0
var can_attack: bool = true

@export var combo_time: float = 0.8

func _ready():
	sword.visible = true
	dagger.visible = false
	axe.visible = false
	_updateAttackHitbox()
	
func _physics_process(delta: float) -> void:
	# =========================
	# MOVIMIENTO
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
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
	if Input.is_action_just_pressed("attack") and can_attack:
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
			max_combo = 3
			attack_delay = sword.attack_delay
			cooldown = 1.0
		"dagger":
			damage = dagger_damage
			max_combo = 4
			attack_delay = 0.08
			cooldown = 0.6
		"axe":
			damage = axe_damage
			max_combo = 2
			attack_delay = 0.35
			cooldown = 1.5

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
			return dagger_distance
		"axe":
			return axe_distance
	return 50.0

# =========================
# TAMAÑO DEL HITBOX
func _updateAttackHitbox():
	match current_weapon:
		"sword":
			attack_hitbox = sword.hitbox
			attack_shape = sword.hitbox_shape
		"dagger":
			attack_hitbox = dagger.hitbox
			attack_shape = dagger.hitbox_shape
		"axe":
			attack_hitbox = axe.hitbox
			attack_shape = axe.hitbox_shape
