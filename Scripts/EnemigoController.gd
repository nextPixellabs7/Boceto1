class_name EnemyController extends CharacterBody2D

@export var vida_component: HealthComponent
@export var vision_component: VisionComponent
@export var deteccion_component: DetectionComponent
@export var movimiento_component: MovementComponent
@export var ataque_component: AttackComponent

@export var pivote: Node2D

enum STATE{
	idle,
	persiguiendo,
	caminando,
	atacando,
	patruyando
}

var estado_actual = STATE.idle
var ultima_posicion_conocida: Vector2 = Vector2.ZERO

func _ready() -> void:
	
	velocity = Vector2.ZERO
	vida_component.muerte.connect(_died)
	vision_component.jugador_detectado.connect(_lookAtPlayer)
	
	vision_component.raycast.add_exception(self)
	
	#vision_component.mirar.connect(_look)
	#deteccion_component.sonido.connect(_look)

func _physics_process(delta: float) -> void:
	
	if estado_actual == STATE.persiguiendo:
		var direccion = pivote.global_position.direction_to(ultima_posicion_conocida)
		var angulo_objetivo = direccion.angle()
		pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo_objetivo, 10.0 * delta)
		#pivote.look_at(ultima_posicion_conocida)
		var caminando = movimiento_component._move(ultima_posicion_conocida)
		
		if not caminando:
			if vision_component.player == null:
				estado_actual = STATE.idle
				print("Ok, a esta distancia estoy joya")
			else:
				estado_actual = STATE.atacando
				print("Te wa a pegar >:v")
	elif estado_actual == STATE.atacando:
		
		var direccion = pivote.global_position.direction_to(ultima_posicion_conocida)
		var angulo_objetivo = direccion.angle()
		pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo_objetivo, 10.0 * delta)
		#pivote.look_at(ultima_posicion_conocida)
		var caminando = movimiento_component._move(ultima_posicion_conocida)
		
		if caminando:
			print("Perate tantito")
			estado_actual = STATE.persiguiendo
		else:
			if ataque_component._checkCD() and vision_component.player != null:
				ataque_component._doDamage(vision_component.player)
				print("Le pegaste al jugador ",ataque_component.damage, " de daño")

func _takeDamage(dmg: int) -> void:
	vida_component._takeDamage(dmg)

func _died() -> void:
	queue_free()

"""
func _look(sonido: Node2D, velocidad: float) -> void:
	
	var sonido_posicion = sonido.global_position
	var angulo_objetivo = pivote.global_position.angle_to_point(sonido_posicion)
	rotation = lerp_angle(rotation, angulo_objetivo, velocidad * 1)
	#pivote.look_at(sonido.global_position)
"""

func _lookAtPlayer(player: CharacterBody2D) -> void:
	ultima_posicion_conocida = player.global_position
	
	
	
	if estado_actual == STATE.idle:
		estado_actual = STATE.persiguiendo
