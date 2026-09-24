class_name VisionComponent extends Node2D

@onready var raycast: RayCast2D = $RayCast2D
var player: Node = null
var seen: bool = false
var velocity

func _seen() -> void:
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



func _on_vision_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		seen = true


func _on_vision_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		seen = false
