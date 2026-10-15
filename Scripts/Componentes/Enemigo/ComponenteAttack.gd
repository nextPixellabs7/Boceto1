class_name AttackComponent extends Node2D

@export var damage: int = 5
@export var cooldown: float = 3.0
var timer: float = 0.0

func _physics_process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta

func do_damage(body: Node2D) -> void:
	if body.has_method("_take_damage"):
		body._take_damage(damage, global_position)
	elif body.has_method("_takeDamage"):
		body._takeDamage(damage)
	timer = cooldown

func can_attack() -> bool:
	return timer <= 0.0

# Alias de compatibilidad con EnemyController
func _doDamage(body: CharacterBody2D) -> void:
	do_damage(body)

func _checkCD() -> bool:
	return can_attack()
