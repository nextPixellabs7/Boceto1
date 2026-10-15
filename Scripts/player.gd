extends CharacterBody2D

@export var max_health := 100.0
@export var max_stamina := 100.0
@export var speed := 150.0
@export var sprint_speed := 600.0
@export var stamina_drain_per_sec := 25.0
@export var stamina_regen_amount := 1.0
@export var stamina_regen_interval := 2.0

var health: float
var stamina: float
var has_key := false
var is_dead := false
var stamina_regen_timer := 0.0
var current_interactable: Node = null   # lo que esté dentro de un área de interacción (ej. la puerta)

func _ready() -> void:
	add_to_group("player")
	health = max_health
	stamina = max_stamina

func _physics_process(delta: float) -> void:
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

	if stamina < max_stamina:
		stamina_regen_timer += delta
		if stamina_regen_timer >= stamina_regen_interval:
			stamina_regen_timer = 0.0
			stamina = clampf(stamina + stamina_regen_amount, 0.0, max_stamina)
	else:
		stamina_regen_timer = 0.0

	velocity = input_dir * current_speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_interact()

func _interact() -> void:
	if current_interactable and current_interactable.has_method("interact"):
		current_interactable.interact(self)
	else:
		print("no se utiliza en este lugar")

func take_damage(amount: float) -> void:
	if is_dead:
		return
	health = clampf(health - amount, 0.0, max_health)
	print("Recibiste ", amount, " de daño. Vida actual: ", health)
	if health <= 0.0:
		is_dead = true
		print("has muerto")
		get_tree().reload_current_scene()

func heal(amount: float) -> void:
	health = clampf(health + amount, 0.0, max_health)

func restore_stamina(amount: float) -> void:
	stamina = clampf(stamina + amount, 0.0, max_stamina)
