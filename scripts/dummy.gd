extends CharacterBody2D

@export var health: int = 200

func take_damage(damage: int):
	print("RECIBÍ DAÑO: ", damage)

	health -= damage
	if health <= 0:
		print("ENEMIGO MUERTO")
		queue_free()
