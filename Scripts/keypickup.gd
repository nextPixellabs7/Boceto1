extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if has_node("Polygon2D"):
		$Polygon2D.color = Color.YELLOW

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	body.has_key = true
	print("obtuviste llave")
	queue_free()
