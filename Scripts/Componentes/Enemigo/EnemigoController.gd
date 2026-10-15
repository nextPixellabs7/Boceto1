class_name EnemyController extends CharacterBody2D

@export var vida_component: HealthComponent
@export var vision_component: VisionComponent
@export var deteccion_component: DetectionComponent
@export var movimiento_component: MovementComponent
@export var ataque_component: AttackComponent

@export var pivote: Node2D

@export var ruta: Path2D
var indice: int = 0

enum STATE{
	idle,
	persiguiendo,
	mirando,
	vigilando,
	caminando,
	atacando,
	patrullando
}

var estado_actual
var ultima_posicion_conocida: Vector2 = Vector2.ZERO

func _ready() -> void:
	velocity = Vector2.ZERO
	
	if ruta:
		estado_actual = STATE.patrullando
	else:
		estado_actual = STATE.idle
	
	if vida_component:
		vida_component.muerte.connect(_died)
	
	if vision_component:
		vision_component.jugador_detectado.connect(_lookAtPlayer)
		vision_component.raycast.add_exception(self)
	
	if deteccion_component:
		deteccion_component.sonido.connect(_look)

func _physics_process(delta: float) -> void:
	# Si no tiene movimiento ni visión, es un enemigo estático/dummy y se queda quieto
	if not movimiento_component or not pivote:
		move_and_slide()
		return

	match estado_actual:


# ===============================================
		STATE.persiguiendo:
			
			# Busca la direccion a ir
			var direccion = pivote.global_position.direction_to(ultima_posicion_conocida)
			var angulo_objetivo = direccion.angle()
			pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo_objetivo, 10.0 * delta)
			# Gira la vision del enemigo en base al angulo a mirar (Es como el "look_at")
			
			# Llama la funcion move para mover al personaje a la ultima posicion
			var caminando = movimiento_component._move(ultima_posicion_conocida, 350.0)
			
			# Si ya no está caminando, se ejecuta lo demás
			if not caminando:
				
				# Si el enemigo ya no ve a nadie, se queda idle
				if vision_component and vision_component.player == null:
					print("onde tai")
					vision_component._prepareWatch()
					estado_actual = STATE.vigilando
					
				# Si el enemigo tiene componente de ataque, entonces ataca (Puesto que está a la distancia perfecta)
				elif ataque_component:
					estado_actual = STATE.atacando
				
				# Si no ve al enemigo ni va a atacar, queda idle
				else:
					if ruta:
						estado_actual = STATE.patrullando
					else:
						estado_actual = STATE.idle
# ===============================================
		STATE.patrullando:
			var posicion_local = ruta.curve.get_point_position(indice)
			var posicion_global = ruta.to_global(posicion_local)
			
			var patruyando = movimiento_component._move(posicion_global, 10.0)
			var direccion = pivote.global_position.direction_to(posicion_global)
			var angulo_objetivo = direccion.angle()
			pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo_objetivo, 10.0 * delta)
			
			if not patruyando:
				indice += 1
				
				if indice >= ruta.curve.get_point_count():
					indice = 0
				
				vision_component._prepareWatch()
				estado_actual = STATE.vigilando

# ===============================================
		STATE.atacando:
			# Si no existe el componente de ataque, pos pasa de largo
			if not ataque_component:
				if ruta:
					estado_actual = STATE.patrullando
				else:
					estado_actual = STATE.idle
				return

			# Gira la vision del enemigo hacia donde está la última posición (Para que no quede estatico mirando a un lado)
			var direccion = pivote.global_position.direction_to(ultima_posicion_conocida)
			var angulo_objetivo = direccion.angle()
			pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo_objetivo, 10.0 * delta)
			var caminando = movimiento_component._move(ultima_posicion_conocida, 350.0)
			# Lo mismo de moverse, para que este no quede congelado y siempre mire al jugador

			if caminando:
				estado_actual = STATE.persiguiendo
			else:
				
				# Verifica que todo exista para poder atacar
				if ataque_component._checkCD() and vision_component and vision_component.player != null:
					
					# Revisa la distancia con el jugador (para no hacer ataques bluetooth
					var distancia_real = global_position.distance_to(vision_component.player.global_position)
					
					# Si la distancia es adecuada, ataca, si no, continua persiguiendo
					if distancia_real <= movimiento_component.distancia_max + 10.0:
						ataque_component._doDamage(vision_component.player)
					else:
						estado_actual = STATE.persiguiendo
				elif vision_component and vision_component.player == null:
					vision_component._prepareWatch()
					estado_actual = STATE.vigilando

# ===============================================
		# Hace que gire hacia donde escuchó "ruido"
		STATE.mirando:
			var direccion = pivote.global_position.direction_to(ultima_posicion_conocida)
			var angulo_objetivo = direccion.angle()
			pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo_objetivo, 10.0 * delta)

# ===============================================
		STATE.vigilando:
			# Ejecuta la función "lookAround" lo que hace que mire hacia cuatro lugares diferentes
			var angulo = vision_component._lookAround()
			if angulo[0]:
				pivote.global_rotation = lerp_angle(pivote.global_rotation, angulo[1], 10.0 * delta)
			else:
				if ruta:
					estado_actual = STATE.patrullando
				else:
					estado_actual = STATE.idle

# Recibir daño desde las armas del Player
func _take_damage(dmg: int, _source_position: Vector2 = Vector2.INF) -> void:
	if vida_component:
		vida_component._takeDamage(dmg)

# Recibir daño
func _takeDamage(dmg: int) -> void:
	_take_damage(dmg)

# Morir :v
func _died() -> void:
	queue_free()

# Toma la última posición conocida y la manda a la función mirar del VisionComponent
func _look(sonido: Node2D) -> void:
	ultima_posicion_conocida = sonido.global_position
	if estado_actual != STATE.mirando:
		estado_actual = STATE.mirando

# Funciona exactamente que la funcion de arriba, pero se ocupa para poder diferenciar funciones
func _lookAtPlayer(player: CharacterBody2D) -> void:
	ultima_posicion_conocida = player.global_position
	if estado_actual == STATE.idle or estado_actual == STATE.mirando:
		estado_actual = STATE.persiguiendo
