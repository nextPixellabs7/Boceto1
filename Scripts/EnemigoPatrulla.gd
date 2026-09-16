extends "res://Scripts/EnemigoBase.gd"

@export var puntosPatrulla: Array

var estado


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	estado = "Idle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
