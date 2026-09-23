extends CharacterBody2D

@export var health: int = 100
@export var contact_damage: int = 10
@export var damage_cooldown: float = 0.8

@onready var damage_area: Area2D = $DamageArea

var can_damage: bool = true


func _ready():
	damage_area.body_entered.connect(_onDamageAreaBodyEntered)


# =========================
# PLAYER ENTRA AL AREA
func _onDamageAreaBodyEntered(body):

	print("ENTRÓ AL DAMAGE AREA: ", body.name)

	if body.is_in_group("player"):
		print("ES EL PLAYER")

		if body.has_method("_takedamage"):
			print("EL PLAYER TIENE TAKEDAMAGE")
			_damagePlayer(body)

# =========================
# HACER DAÑO

func _damagePlayer(body):

	if not can_damage:
		return

	can_damage = false

	print("DUMMY ATACÓ AL PLAYER")

	body._takedamage(contact_damage)

	await get_tree().create_timer(damage_cooldown).timeout

	can_damage = true


# =========================
# RECIBIR DAÑO

func _takedamage(damage: int):

	print("DUMMY RECIBIÓ DAÑO: ", damage)

	health -= damage

	print("VIDA DEL DUMMY: ", health)

	if health <= 0:
		print("DUMMY MUERTO")
		queue_free()
