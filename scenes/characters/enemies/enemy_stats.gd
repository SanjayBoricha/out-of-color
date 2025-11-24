extends Resource
class_name EnemyStats

@export var name: String
@export var type: Global.EnemyTypes
@export var speed: float
@export var hp: int

func get_sprite_animation():
	match type:
		Global.EnemyTypes.CIRCLE:
			return "circle"
		Global.EnemyTypes.TRIANGLE:
			return "triangle"
		Global.EnemyTypes.SQUARE:
			return "square"
