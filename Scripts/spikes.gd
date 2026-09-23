extends Area2D

@export var damage := 15.0
@export var damage_interval := 0.5

var body_inside: Node2D = null

#@onready var damage_timer: Timer = $DamageTimer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	#damage_timer.wait_time = damage_interval
	#damage_timer.timeout.connect(_on_timer_timeout)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	body_inside = body
	body.take_damage(damage)
	#damage_timer.start()

func _on_body_exited(body: Node2D) -> void:
	if body == body_inside:
		body_inside = null
		#damage_timer.stop()

func _on_timer_timeout() -> void:
	if body_inside:
		body_inside.take_damage(damage)
