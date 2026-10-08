class_name VisionComponent extends Node2D

@export var conoVision : Area2D
@export var raycast: RayCast2D
var player: CharacterBody2D
var seen: bool = false

signal jugador_detectado(body: CharacterBody2D)
signal mirar(lugar: Node2D)

var angle_cone_of_vision := deg_to_rad(30.0)
var max_view_distance := 800.0
var angle_between_rays := deg_to_rad(5.0)


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
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
