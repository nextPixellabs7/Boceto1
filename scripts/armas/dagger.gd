extends Node2D


# =========================
# DATOS DE LA DAGA
# =========================

@export var damage: int = 10
@export var attack_distance: float = 35.0
@export var attack_delay: float = 0.08
@export var max_combo: int = 4
@export var cooldown: float = 0.6

@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D
