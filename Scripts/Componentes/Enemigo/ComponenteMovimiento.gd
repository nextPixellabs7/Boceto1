class_name MovementComponent extends Node2D

@export var body: CharacterBody2D
@export var nav_agent: NavigationAgent2D

var speed = 150
var ultima_posicion: Vector2

@export var distancia_min : float = 345.0
@export var distancia_max : float = 350.0

func _move(destino: Vector2) -> bool:
	
	
	if not body or not nav_agent: 
		print("AYUDA: me falta mi cuerpo o mi Navigation Agent en el inspector")
		return false
	
	nav_agent.target_position = destino
	var distancia = body.global_position.distance_to(destino)
	#var direccion = body.global_position.direction_to(destino)
	
	if distancia >= distancia_max:
		
		var siguiente_paso = nav_agent.get_next_path_position()
		var direccion = body.global_position.direction_to(siguiente_paso)
		
		body.velocity = direccion * speed
		body.move_and_slide() 
		return true 
	elif distancia <= distancia_min:
		var direccion = body.global_position.direction_to(destino)
		body.velocity = -direccion * speed
		body.move_and_slide() 
		return true
	else:
		body.velocity = Vector2.ZERO
		return false
