class_name Health
extends Node

# =========================
# SEÑALES
signal changed(current: int, maximum: int)
signal damage_taken(amount: int)
signal healed(amount: int)
signal died

# =========================
# DATOS
@export var max_health: int = 100
var current: int

# =========================
# INICIO
func _ready() -> void:
	current = max_health
	changed.emit(current, max_health)

# =========================
# RECIBIR DAÑO
func take_damage(amount: int) -> void:
	if current <= 0 or amount <= 0:
		return
	
	current = clampi(current - amount, 0, max_health)
	damage_taken.emit(amount)
	changed.emit(current, max_health)
	
	if current == 0:
		died.emit()

# =========================
# CURACIÓN
func heal(amount: int) -> void:
	if current <= 0 or amount <= 0 or current >= max_health:
		return
	
	current = clampi(current + amount, 0, max_health)
	healed.emit(amount)
	changed.emit(current, max_health)
