extends Resource
class_name EnemyStats

@export var name: String
@export var type: Global.EnemyTypes
@export var speed: float
@export var hp: int

func get_sprite_texture():
	match type:
		Global.EnemyTypes.CIRCLE:
			return load("res://assets/characters/slime.png")
		Global.EnemyTypes.TRIANGLE:
			return load("res://assets/characters/triangle.png")
		Global.EnemyTypes.SQUARE:
			return load("res://assets/characters/square.png")
