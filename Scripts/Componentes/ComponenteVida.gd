class_name HealthComponent extends Node2D


@export var vida: float

func _takeDamage(damage: float) -> void:
	vida -= damage
	
	emit_signal("vida_actualizada", vida)
	
	if vida <= 0:
		emit_signal("muerte")
