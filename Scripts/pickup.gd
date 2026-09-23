extends Area2D

@export var heal_amount := 25.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if has_node("Polygon2D"):
		$Polygon2D.color = Color.RED

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	body.heal(heal_amount)
	print("Tomaste el consumible de Vida (+", heal_amount, " HP)")
	queue_free()
