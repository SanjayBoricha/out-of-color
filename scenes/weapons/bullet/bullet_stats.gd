extends Resource
class_name BulletStats

@export var name: String
@export var type: Global.BulletType
@export var speed: float
@export var damage: int = 1
@export var aoe: bool = false
@export var dot: int = 0
@export var freeze: bool = false

func get_sprite_texture():
	match type:
		Global.BulletType.RED:
			return load("res://assets/weapons/bullets/red_bullet.png")
		Global.BulletType.GREEN:
			return load("res://assets/weapons/bullets/green_bullet.png")
		Global.BulletType.BLUE:
			return load("res://assets/weapons/bullets/blue_bullet.png")
