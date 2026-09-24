extends Node2D


# =========================
# DATOS DE LA ESPADA
# =========================

@export var damage: int = 20
@export var attack_distance: float = 50.0
@export var attack_delay: float = 0.15
@export var max_combo: int = 3
@export var cooldown: float = 1.05

@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D
