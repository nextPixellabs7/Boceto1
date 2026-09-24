extends Node
# =========================
# REFERENCIA AL PLAYER

@onready var player = get_parent().get_parent()

# =========================
# COMPROBAR SI PUEDE ATACAR
func _canEnter() -> bool:
	return Input.is_action_just_pressed("attack")
# =========================
# EJECUTAR ATAQUE
func _execute():
	player.can_attack = false
	var damage = 0
	var max_combo = 1
	var attack_delay = 0.15
	var cooldown = 0.5
	# =========================
	# CONFIGURAR ARMA
	match player.current_weapon:
		"sword":
			damage = player.sword.damage
			max_combo = player.sword.max_combo
			attack_delay = player.sword.attack_delay
			cooldown = player.sword.cooldown
		"dagger":
			damage = player.dagger.damage
			max_combo = player.dagger.max_combo
			attack_delay = player.dagger.attack_delay
			cooldown = player.dagger.cooldown
		"axe":
			damage = player.axe.damage
			max_combo = player.axe.max_combo
			attack_delay = player.axe.attack_delay
			cooldown = player.axe.cooldown
	# =========================
	# AVANZAR COMBO
	player.combo_step += 1
	if player.combo_step > max_combo:
		player.combo_step = 1
	print(
		player.current_weapon,
		" - golpe ",
		player.combo_step
	)
	# =========================
	# ACTIVAR HITBOX
	player.attack_hitbox.monitoring = true
	await get_tree().physics_frame
	var bodies = player.attack_hitbox.get_overlapping_bodies()
	print("Cuerpos detectados: ", bodies.size())
	# =========================
	# HACER DAÑO
	for body in bodies:
		print("Detectado: ", body.name)
		if body.has_method("_takedamage"):
			body._takedamage(damage)
	# =========================
	# DESACTIVAR HITBOX
	player.attack_hitbox.monitoring = false
	# =========================
	# ESPERA ENTRE GOLPES
	await get_tree().create_timer(attack_delay).timeout
	# =========================
	# FIN DEL COMBO
	if player.combo_step == max_combo:
		print("FIN DEL COMBO")
		await get_tree().create_timer(cooldown).timeout
		player.combo_step = 0
		player.combo_timer = 0
	else:
		player.combo_timer = player.combo_time
	player.can_attack = true
