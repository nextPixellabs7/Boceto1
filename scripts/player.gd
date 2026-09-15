extends CharacterBody2D

@export var speed: float = 200.0
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D
var current_weapon: String = "sword"
var sword_damage: int = 20
var dagger_damage: int = 10
var axe_damage: int = 40


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = direction * speed
	move_and_slide()
	# Mirar hacia el mouse
	look_at(get_global_mouse_position())
	# Cambiar arma

	if Input.is_action_just_pressed("weapon_sword"):
		current_weapon = "sword"
		update_hitbox()
		print("Espada larga equipada")

	if Input.is_action_just_pressed("weapon_dagger"):
		current_weapon = "dagger"
		update_hitbox()
		print("Daga equipada")

	if Input.is_action_just_pressed("weapon_axe"):
		current_weapon = "axe"
		update_hitbox()
		print("Gran hacha equipada")

	# Ataque
	if Input.is_action_just_pressed("attack"):
		attack()


func attack():
	attack_hitbox.monitoring = true
	var damage = 0
	match current_weapon:
		"sword":
			damage = sword_damage
			print("Ataque de espada")

		"dagger":
			damage = dagger_damage
			print("Ataque de daga")

		"axe":
			damage = axe_damage
			print("Ataque de gran hacha")
	await get_tree().physics_frame
	var bodies = attack_hitbox.get_overlapping_bodies()

	print("Cuerpos detectados: ", bodies.size())

	for body in bodies:
		print("Detectado: ", body.name)

		if body.has_method("take_damage"):
			body.take_damage(damage)
	attack_hitbox.monitoring = false

func update_hitbox():
	match current_weapon:
		"sword":
			attack_shape.shape.size = Vector2(80, 40)

		"dagger":
			attack_shape.shape.size = Vector2(50, 25)

		"axe":
			attack_shape.shape.size = Vector2(120, 60)
