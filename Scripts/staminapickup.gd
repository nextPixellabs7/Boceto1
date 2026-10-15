extends Area2D

@export var stamina_amount := 25.0
@export var respawn_time := 15.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if has_node("Polygon2D"):
		$Polygon2D.color = Color.GREEN

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	body.restore_stamina(stamina_amount)
	print("Tomaste el consumible de Estamina (+", stamina_amount, " STA)")
	_start_respawn()

func _start_respawn() -> void:
	visible = false
	monitoring = false
	await get_tree().create_timer(respawn_time).timeout
	visible = true
	monitoring = true
	print("El consumible de Estamina reapareció")
