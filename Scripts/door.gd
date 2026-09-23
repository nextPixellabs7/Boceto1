extends StaticBody2D

@export var interact_range := 40.0

var is_open := false

@onready var collision: CollisionShape2D = $CollisionShape2D

func _process(_delta: float) -> void:
	if is_open:
		return

	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var distance := global_position.distance_to(player.global_position)
	if distance <= interact_range and Input.is_action_just_pressed("interact"):
		if player.has_key:
			is_open = true
			collision.set_deferred("disabled", true)
			print("puerta abierta")
		else:
			print("Necesitas una llave para abrir la puerta")
