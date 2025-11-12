class_name EnemyStats
extends Resource

@export var name: String
@export var health: int
@export var speed: float

func _init(p_name = "Enemy", p_health = 0, p_speed = 100.0):
	name = p_name
	health = p_health
	speed = p_speed
