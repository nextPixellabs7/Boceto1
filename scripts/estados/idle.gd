extends Node
# =========================
# REFERENCIA AL PLAYER
@onready var player = owner
# =========================
# CICLO DEL ESTADO
func _enter() -> void:
	pass
func _exit() -> void:
	pass
func _physics_update(_direction: Vector2, _delta: float) -> void:
	player.velocity = Vector2.ZERO
