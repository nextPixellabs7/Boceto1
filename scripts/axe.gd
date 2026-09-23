extends Node2D


# =========================
# DATOS DEL HACHA
# =========================

@export var damage: int = 40
@export var attack_distance: float = 70.0
@export var attack_delay: float = 0.35

@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D
