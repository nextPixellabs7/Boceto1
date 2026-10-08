class_name AttackComponent extends Node2D

@export var damage := 5
@export var cooldown := 2
var timer := 0.0

func _physics_process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta

func _doDamage(body: CharacterBody2D) -> void:
	body._takeDamage(damage)
	timer = cooldown
	
func _checkCD() -> float:
	return timer <= 0.0
