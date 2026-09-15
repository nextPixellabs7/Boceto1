extends CharacterBody2D

@export var speed: float = 200.0
@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var attack_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D
var current_weapon: String = "sword"



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
	match current_weapon:
		"sword":
			print("Ataque de espada")

		"dagger":
			print("Ataque de daga")

		"axe":
			print("Ataque de gran hacha")
	await get_tree().create_timer(0.15).timeout

func update_hitbox():
	match current_weapon:
		"sword":
			attack_shape.shape.size = Vector2(80, 40)

		"dagger":
			attack_shape.shape.size = Vector2(50, 25)

		"axe":
			attack_shape.shape.size = Vector2(120, 60)
