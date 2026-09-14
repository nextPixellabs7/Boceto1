extends CharacterBody2D

@export var speed: float = 200.0

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
		print("Espada larga equipada")

	if Input.is_action_just_pressed("weapon_dagger"):
		current_weapon = "dagger"
		print("Daga equipada")

	if Input.is_action_just_pressed("weapon_axe"):
		current_weapon = "axe"
		print("Gran hacha equipada")

	# Ataque
	if Input.is_action_just_pressed("attack"):
		attack()


func attack():
	match current_weapon:
		"sword":
			print("Ataque de espada")

		"dagger":
			print("Ataque de daga")

		"axe":
			print("Ataque de gran hacha")
