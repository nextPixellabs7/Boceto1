class_name DetectionComponent extends Node2D


@onready var raycast: RayCast2D = $RayCast2D
var player: Node = null
var near: bool = false

func _checkPlayer() -> void:

	if player != null and near:
			print("Se que estas cerca...")
	else:
		print("No sé donde estás... :(")


func _on_entorno_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		near = true
		player = body


func _on_entorno_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player = null
		near = false
