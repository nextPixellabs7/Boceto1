class_name DetectionComponent extends Node2D

signal sonido(body: Node2D)

var player: CharacterBody2D = null
var near: bool = false
var velocidad_giro: float = 5

func _checkPlayer() -> void:
	pass
		


func _on_entorno_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		sonido.emit(body)


func _on_entorno_body_exited(body: Node2D) -> void:
	
	if body is Player:
		player = null
