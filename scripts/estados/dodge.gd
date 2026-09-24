extends Node

# =========================
# REFERENCIA AL PLAYER

@onready var player = get_parent().get_parent()


# =========================
# DATOS DEL DODGE

@export var dodge_speed: float = 600.0
@export var dodge_duration: float = 0.2
@export var dodge_cooldown: float = 0.8

var can_dodge: bool = true


# =========================
# COMPROBAR SI PUEDE ENTRAR

func _canEnter(direction: Vector2) -> bool:

	if direction == Vector2.ZERO:
		return false

	if not can_dodge:
		return false

	return Input.is_action_just_pressed("dodge")


# =========================
# EJECUTAR DODGE

func _execute(direction: Vector2):

	if not can_dodge:
		return

	player.is_dodging = true
	can_dodge = false

	var dodge_direction = direction.normalized()

	player.velocity = dodge_direction * dodge_speed

	await get_tree().create_timer(dodge_duration).timeout

	player.velocity = Vector2.ZERO
	player.is_dodging = false

	await get_tree().create_timer(dodge_cooldown).timeout

	can_dodge = true
