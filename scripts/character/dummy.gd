extends CharacterBody2D
# =========================
# DATOS
@export var health: int = 100
@export var contact_damage: int = 10
@export var damage_cooldown: float = 0.8

@onready var damage_area: Area2D = $DamageArea

var can_damage: bool = true
# =========================
# CONTACTO (se revisa cada frame físico)
func _physics_process(_delta: float) -> void:
	if not can_damage:
		return
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			_damagePlayer(body)
			break
# =========================
# HACER DAÑO
func _damagePlayer(body) -> void:
	can_damage = false
	print("DUMMY ATACÓ AL PLAYER")
	body._takedamage(contact_damage)
	await get_tree().create_timer(damage_cooldown).timeout
	can_damage = true
# =========================
# RECIBIR DAÑO
func _takedamage(damage: int) -> void:
	print("DUMMY RECIBIÓ DAÑO: ", damage)
	health -= damage
	print("VIDA DEL DUMMY: ", health)
	if health <= 0:
		print("DUMMY MUERTO")
		queue_free()
