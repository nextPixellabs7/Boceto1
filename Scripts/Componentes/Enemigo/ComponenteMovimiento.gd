class_name MovementComponent extends Node2D

@export var body: CharacterBody2D
#@export var nav_agent: NavigationAgent2D

var speed = 150
var ultima_posicion: Vector2

@export var distancia_min : float = 345.0
@export var distancia_max : float = 350.0

func _move(destino: Vector2) -> bool:
	
	
	if not body: return false
	
	var distancia = body.global_position.distance_to(destino)
	var direccion = body.global_position.direction_to(destino)
	
	if distancia >= distancia_max:
		
		body.velocity = direccion * speed
		body.move_and_slide() 
		return true 
	elif distancia <= distancia_min:
		body.velocity = -direccion * speed
		body.move_and_slide() 
		return true
	else:
		body.velocity = Vector2.ZERO
		return false
	
	""" Este es una prueba con el navigation Agent
	var distancia = body.global_position.distance_to(destino)
	
	if nav_agent.is_navigation_finished():
		body.velocity = Vector2.ZERO
		return false

	var siguiente_paso = nav_agent.get_next_path_position()
	var direction = body.global_position.direction_to(siguiente_paso)
	
	body.velocity = direction * speed
	body.move_and_slide() 


#func _crearCamino() -> void:
	#nav_agent.target_position = ultima_posicion

func _on_timer_timeout() -> void:
	#_crearCamino()
	pass
	""" 
