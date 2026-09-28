extends State
func _physics_update(direction: Vector2, _delta: float) -> void:
	player.velocity = direction * player.speed
