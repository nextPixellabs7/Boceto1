extends CharacterBody2D

@export var speed: float = 200.0
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D

var current_weapon: String = "sword"

var sword_damage: int = 20
var dagger_damage: int = 10
var axe_damage: int = 40

# Sistema de combos
var combo_step: int = 0
var combo_timer: float = 0.0
var can_attack: bool = true

@export var combo_time: float = 0.8

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	
	velocity = direction * speed
	move_and_slide()

	# Mirar hacia el mouse
	look_at(get_global_mouse_position())


	# =========================
	# TEMPORIZADOR DEL COMBO
	# =========================

	if combo_timer > 0:
		combo_timer -= delta

		if combo_timer <= 0:
			combo_step = 0


	# =========================
	# CAMBIAR ARMA
	# =========================

	if Input.is_action_just_pressed("weapon_sword"):
		current_weapon = "sword"
		combo_step = 0
		combo_timer = 0
		update_hitbox()
		print("Espada larga equipada")

	if Input.is_action_just_pressed("weapon_dagger"):
		current_weapon = "dagger"
		combo_step = 0
		combo_timer = 0
		update_hitbox()
		print("Daga equipada")

	if Input.is_action_just_pressed("weapon_axe"):
		current_weapon = "axe"
		combo_step = 0
		combo_timer = 0
		update_hitbox()
		print("Gran hacha equipada")


	# =========================
	# ATAQUE
	# =========================

	if Input.is_action_just_pressed("attack") and can_attack:
		attack()

func attack():
	can_attack = false

	var damage = 0
	var max_combo = 1
	var attack_delay = 0.15
	var cooldown = 0.5

	# =========================
	# CONFIGURAR ARMA
	# =========================

	match current_weapon:

		"sword":
			damage = sword_damage
			max_combo = 3
			attack_delay = 0.15
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
	# =========================

	combo_step += 1

	if combo_step > max_combo:
		combo_step = 1

	print(current_weapon, " - golpe ", combo_step)

	# =========================
	# ACTIVAR HITBOX
	# =========================

	attack_hitbox.monitoring = true

	await get_tree().physics_frame

	var bodies = attack_hitbox.get_overlapping_bodies()

	print("Cuerpos detectados: ", bodies.size())

	for body in bodies:

		print("Detectado: ", body.name)

		if body.has_method("take_damage"):
			body.take_damage(damage)

	# Desactivar hitbox
	attack_hitbox.monitoring = false

	# =========================
	# ESPERA ENTRE GOLPES
	# =========================

	await get_tree().create_timer(attack_delay).timeout

	# =========================
	# FIN DEL COMBO
	# =========================

	if combo_step == max_combo:

		print("FIN DEL COMBO")

		# Descanso después del combo
		await get_tree().create_timer(cooldown).timeout

		combo_step = 0
		combo_timer = 0

	else:

		# Tiempo disponible para continuar el combo
		combo_timer = combo_time

	can_attack = true


func update_hitbox():

	match current_weapon:

		"sword":
			attack_shape.shape.size = Vector2(80, 40)

		"dagger":
			attack_shape.shape.size = Vector2(50, 25)

		"axe":
			attack_shape.shape.size = Vector2(120, 60)
