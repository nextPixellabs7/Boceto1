class_name HealthComponent extends Node2D

signal muerte

@export var vida:= 20
@export var vida_maxima: float

func _ready() -> void:
	vida_maxima = vida

func _takeDamage(damage: int) -> void:
	vida -= damage
	
	if vida <= 0:
		muerte.emit()

func _healDamage(life: int) -> void:
	vida += life
	
	if vida > vida_maxima:
		vida = vida_maxima
