extends Node

# =========================
# COMPROBAR SI ESTÁ QUIETO

func _canEnter(direction: Vector2) -> bool:

	return direction == Vector2.ZERO
