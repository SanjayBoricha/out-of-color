extends Node2D

var enemy = preload("res://scenes/characters/enemies/enemy.tscn")

@onready var king: CharacterBody2D = %King
@onready var enemy_spawn_point: CollisionShape2D = %EnemySpawnPoint

func _on_timer_timeout() -> void:
	var new_enemy: CharacterBody2D = enemy.instantiate()
	new_enemy.target = king
	new_enemy.position = enemy_spawn_point.global_position
	add_child(new_enemy)
