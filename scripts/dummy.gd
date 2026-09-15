extends CharacterBody2D

@export var health: int = 100


func take_damage(damage: int):
	print("RECIBÍ DAÑO: ", damage)

	health -= damage

	print("VIDA RESTANTE: ", health)

	if health <= 0:
		print("ENEMIGO MUERTO")
		queue_free()
