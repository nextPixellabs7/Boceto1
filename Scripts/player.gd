extends CharacterBody2D

@export var max_health := 100.0
@export var max_stamina := 100.0
@export var speed := 150.0
@export var sprint_speed := 260.0
@export var stamina_drain_per_sec := 25.0

var health: float
var stamina: float
var has_key := false
var is_dead := false

func _ready() -> void:
	add_to_group("player")
	health = max_health
	stamina = max_stamina

func _physics_process(delta: float) -> void:
	# Esto es lo que deja al personaje estático al morir: mientras is_dead
	# sea true, la velocidad se fuerza a cero cada frame y el "return"
	# corta la función antes de leer el input. Queda comentado para que,
	# en esta zona de pruebas, sigas moviéndote después de "morir".
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var is_sprinting := Input.is_action_pressed("sprint") and stamina > 0.0 and input_dir != Vector2.ZERO

	var current_speed := speed
	if is_sprinting:
		current_speed = sprint_speed
		stamina = clampf(stamina - stamina_drain_per_sec * delta, 0.0, max_stamina)

	velocity = input_dir * current_speed
	move_and_slide()

func take_damage(amount: float) -> void:
	if is_dead:
		return
	health = clampf(health - amount, 0.0, max_health)
	print("Recibiste ", amount, " de daño. Vida actual: ", health)
	if health <= 0.0:
		is_dead = true
		print("has muerto")
		# Cuando quieras que reinicie el nivel al morir, descomenta esta línea:
		get_tree().reload_current_scene()

func heal(amount: float) -> void:
	health = clampf(health + amount, 0.0, max_health)

func restore_stamina(amount: float) -> void:
	stamina = clampf(stamina + amount, 0.0, max_stamina)
