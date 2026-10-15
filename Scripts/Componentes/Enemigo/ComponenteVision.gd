class_name VisionComponent extends Node2D

@export var conoVision : Area2D
@export var raycast: RayCast2D
var player: CharacterBody2D
var seen: bool = false

var cooldown: float = 3.0
var timer: float = 0.0
var indice
var puntos_a_mirar

signal jugador_detectado(body: CharacterBody2D)
signal mirar(lugar: Node2D)

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 800.0
var angle_between_rays := deg_to_rad(5.0)


func _ready() -> void:
	indice = 0
	pass

func _physics_process(delta: float) -> void:
	
	if timer > 0.0:
		timer -= delta
	elif timer <= 0.0:
		indice += 1
		timer = cooldown
	
	if player == null: return
	
	raycast.target_position = raycast.to_local(player.global_position)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var tarjet = raycast.get_collider()
		
		if tarjet is Player:
			jugador_detectado.emit(player)
			pass

func _look(body: Node2D) -> void:
	mirar.emit(body)

func _lookAround():
	
	if indice < 4:
		return [true ,puntos_a_mirar[indice]]
	else:
		return [false, 0.0]

func _prepareWatch() -> void:
	var val1 = deg_to_rad(randf_range(-90.0, 90))
	var val2 = deg_to_rad(randf_range(-90.0, 90))
	var val3 = deg_to_rad(randf_range(-90.0, 90))
	var val4 = deg_to_rad(randf_range(-90.0, 90))
	puntos_a_mirar = [val1, val2, val3, val4]
	
	indice = 0
	timer = cooldown

func _on_timer_timeout() -> void:
	var encontrados = false
	
	var cuerpos_cercanos = conoVision.get_overlapping_bodies()
	
	for cuerpo in cuerpos_cercanos:
		if cuerpo is Player:
			player = cuerpo
			encontrados = true
			break
	
	if not encontrados:
		player = null
