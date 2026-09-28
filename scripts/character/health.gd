class_name Health
extends Node
# =========================
# SEÑALES
signal changed(current: int, maximum: int)
signal died
# =========================
# DATOS
@export var max_health: int = 100
var current: int
# =========================
# INICIO
func _ready() -> void:
	current = max_health
# =========================
# RECIBIR DAÑO
func _takedamage(amount: int) -> void:
	if current <= 0:
		return
	current = max(current - amount, 0)
	changed.emit(current, max_health)
	if current == 0:
		died.emit()
