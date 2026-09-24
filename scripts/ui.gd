extends CanvasLayer

@onready var player = $"../Player"

@onready var health_bar: ProgressBar = $HealthBar
@onready var health_text: Label = $HealthBar/HealthText
@onready var weapon_icon: TextureRect = $WeaponIcon

func _ready():
	health_bar.max_value = player.max_health
	health_bar.value = player.health
	_updateHealthUI()
	_updateWeaponUI()

func _process(_delta):
	health_bar.value = player.health
	_updateHealthUI()
	_updateWeaponUI()
# =========================
# ACTUALIZAR VIDA
func _updateHealthUI():
	health_text.text = str(player.health) + " / " + str(player.max_health)
# =========================
# ACTUALIZAR ARMA
func _updateWeaponUI():
	match player.current_weapon:
		"sword":
			weapon_icon.texture = player.sword.get_node("Sprite2D").texture
		"dagger":
			weapon_icon.texture = player.dagger.get_node("Sprite2D").texture
		"axe":
			weapon_icon.texture = player.axe.get_node("Sprite2D").texture
