extends CanvasLayer
# =========================
# REFERENCIAS
@onready var player = $"../Player"

@onready var health_bar: ProgressBar = $HealthBar
@onready var health_text: Label = $HealthBar/HealthText
@onready var weapon_icon: TextureRect = $WeaponIcon
# =========================
# INICIO
func _ready() -> void:
	player.health_changed.connect(_on_health_changed)
	player.weapon_changed.connect(_on_weapon_changed)
	# Estado inicial (por si el jugador ya se inicializó antes que el HUD)
	_on_health_changed(player.health, player.max_health)
	_on_weapon_changed(player.current_weapon)
# =========================
# ACTUALIZAR VIDA
func _on_health_changed(current: int, maximum: int) -> void:
	health_bar.max_value = maximum
	health_bar.value = current
	health_text.text = "%d / %d" % [current, maximum]
# =========================
# ACTUALIZAR ARMA
func _on_weapon_changed(weapon_name: String) -> void:
	weapon_icon.texture = player.weapons[weapon_name].get_node("Sprite2D").texture
