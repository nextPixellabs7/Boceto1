extends CharacterBody2D

@onready var areaAtaque = $Area2D

const SPEED = 300.0


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionx := Input.get_axis("ui_left", "ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")
	if directionx:
		velocity.x = directionx * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directiony:
		velocity.y = directiony * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if Input.is_action_just_pressed("ui_accept"):
		_doDamage()

	move_and_slide()
func _doDamage() -> void:
	
	var enemy = areaAtaque.get_overlapping_bodies()
	
	for enemigos in enemy:
		if enemigos.has_method("_takeDamage"):
			if enemigos != self:
				enemigos._takeDamage(5)
				print("Le pegaste al enemigo : %s de vida" % [enemigos.vida])
