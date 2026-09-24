extends CharacterBody2D


enum STATE{
	idle,
	persiguiendo,
	caminando,
	corriendo
}


func _ready() -> void:
	
	velocity = Vector2.ZERO

func _process(delta: float) -> void:
	pass
