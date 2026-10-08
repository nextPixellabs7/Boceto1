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
	mirando,
	caminando,
	atacando,
	patrullando
}

var estado_actual = STATE.idle
var ultima_posicion_conocida: Vector2 = Vector2.ZERO

func _ready() -> void:
	
	velocity = Vector2.ZERO
	vida_component.muerte.connect(_died)
	vision_component.jugador_detectado.connect(_lookAtPlayer)
	
	vision_component.raycast.add_exception(self)
	
	deteccion_component.sonido.connect(_look)

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
			else:
				estado_actual = STATE.atacando
	elif estado_actual == STATE.atacando:
		
		var direccion = pivote.global_position.direction_to(ultima_posicion_conocida)
		var angulo_objetivo = direccion.angle()
		pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo_objetivo, 10.0 * delta)
		var caminando = movimiento_component._move(ultima_posicion_conocida)

		if caminando:
			estado_actual = STATE.persiguiendo
		else:
			if ataque_component._checkCD() and vision_component.player != null:
				
				
				var distancia_real = global_position.distance_to(vision_component.player.global_position)
				if distancia_real <= movimiento_component.distancia_max + 10.0:
					ataque_component._doDamage(vision_component.player)
					print("Le pegaste al jugador ",ataque_component.damage, " de daño")
				else:
					estado_actual = STATE.persiguiendo

	elif estado_actual == STATE.mirando:
		var direccion = pivote.global_position.direction_to(ultima_posicion_conocida)
		var angulo_objetivo = direccion.angle()
		pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo_objetivo, 10.0 * delta)
	
func _takeDamage(dmg: int) -> void:
	vida_component._takeDamage(dmg)

func _died() -> void:
	queue_free()

func _look(sonido: Node2D) -> void:
	
	ultima_posicion_conocida = sonido.global_position
	
	if estado_actual != STATE.mirando:
		estado_actual = STATE.mirando

func _lookAtPlayer(player: CharacterBody2D) -> void:
	ultima_posicion_conocida = player.global_position
	
	if estado_actual == STATE.idle or estado_actual == STATE.mirando:
		estado_actual = STATE.persiguiendo
