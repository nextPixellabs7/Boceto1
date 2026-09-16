extends CharacterBody2D

@onready var sprite = $Sprite2D

var vida: float = 20
@onready var raycast: RayCast2D = $RayCast2D
var player: Node = null
var near: bool = false
var seen: bool = false

enum STATE{
	idle,
	persiguiendo,
	caminando,
	corriendo
}


func _ready() -> void:
	
	velocity = Vector2.ZERO

func _process(delta: float) -> void:
	
	
	#sprite.rotation_degrees += 0.5 * 1
	
	_checkPlayer()
	
	move_and_slide()

func _checkPlayer() -> void:
	if player != null and near:
		print("Se que estas cerca...")
		if seen:
			raycast.target_position = to_local(player.global_position)
			raycast.force_raycast_update()
			
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider.name == "Player":
					
					var direction = global_position.direction_to(player.global_position)
					velocity = direction * 150
					look_at(player.global_position)
					#print("Te veo!")
				else:
					pass
					#print("No te veo, pero sé que estás ahí")
	

func _takeDamage(damage: float) -> void:
	vida -= damage
	
	if vida <= 0:
		_Die()

func _Die() -> void:
	queue_free()

func _on_rango_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		near = true
		player = body
	


func _on_rango_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Player":
		player = null
		near = false
		#print("No se donde estas...")


func _on_vision_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		seen = true


func _on_vision_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		seen = false
		#print("Ya no te veo...")
