class_name HealthComponent extends Node2D

signal muerte
signal vida_cambiada(actual: int, maxima: int)

@export var vida: int = 200
@export var vida_maxima: int = 200

func _ready() -> void:
	vida_maxima = vida

func take_damage(amount: int) -> void:
	if vida <= 0 or amount <= 0:
		return
	vida = clampi(vida - amount, 0, vida_maxima)
	vida_cambiada.emit(vida, vida_maxima)
	
	if vida == 0:
		muerte.emit()

# Alias temporal por compatibilidad si algún script viejo aún lo llama:
func _takeDamage(dmg: int) -> void:
	take_damage(dmg)

func heal(amount: int) -> void:
	if vida <= 0 or amount <= 0:
		return
	vida = clampi(vida + amount, 0, vida_maxima)
	vida_cambiada.emit(vida, vida_maxima)
