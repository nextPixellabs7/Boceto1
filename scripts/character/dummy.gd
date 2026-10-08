extends CharacterBody2D

# =========================
# DATOS
@export var contact_damage: int = 10
@export var damage_cooldown: float = 0.8

@onready var damage_area: Area2D = $DamageArea
@onready var health: Health = $Health

var can_damage: bool = true

# =========================
# INICIO
func _ready() -> void:
	health.died.connect(_on_died)

# =========================
# CONTACTO
func _physics_process(_delta: float) -> void:
	if not can_damage:
		return
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			_damage_player(body)
			break

# =========================
# HACER DAÑO
func _damage_player(body: Node2D) -> void:
	can_damage = false
	print("DUMMY ATACÓ AL PLAYER")
	if body.has_method("_take_damage"):
		body._take_damage(contact_damage, global_position)
	
	var timer := get_tree().create_timer(damage_cooldown)
	await timer.timeout
	if is_instance_valid(self):
		can_damage = true

# =========================
# RECIBIR DAÑO
func _take_damage(damage: int, _source_position: Vector2 = Vector2.INF) -> void:
	print("DUMMY RECIBIÓ DAÑO: ", damage)
	health.take_damage(damage)
	print("VIDA DEL DUMMY: ", health.current)

# =========================
# MUERTE
func _on_died() -> void:
	print("DUMMY MUERTO")
	queue_free()
