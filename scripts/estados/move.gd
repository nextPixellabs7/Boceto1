extends Node

# =========================
# COMPROBAR SI SE ESTÁ MOVIENDO

func _canEnter(direction: Vector2) -> bool:

	return direction != Vector2.ZERO
