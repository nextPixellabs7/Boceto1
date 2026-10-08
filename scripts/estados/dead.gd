extends State
# =========================
# ENTRAR AL ESTADO
func _enter() -> void:
	control.state_locked = true
	player.velocity = Vector2.ZERO
	print("PLAYER MUERTO")
# =========================
# ACTUALIZAR (nunca se desbloquea)
func _physics_update(_direction: Vector2, _delta: float) -> void:
	player.velocity = Vector2.ZERO
