extends Node2D

var enemy = preload("res://scenes/characters/enemies/enemy.tscn")

@onready var king: CharacterBody2D = %King
@onready var enemy_spawn_point: CollisionShape2D = %EnemySpawnPoint
@onready var wave_timer: Timer = $WaveTimer
@onready var enemy_timer: Timer = $EnemyTimer

var enemy_type_resources: Array[EnemyStats] = [
	load("res://scenes/characters/enemies/types/circle.tres"),
	load("res://scenes/characters/enemies/types/triangle.tres"),
	load("res://scenes/characters/enemies/types/square.tres")
]

var waves = [
	[[0, 10]],
	[[0, 8], [1, 2]],
	[[0, 3], [1, 7]],
	[[0, 2], [1, 6], [2, 2]],
	[[1, 5], [2, 5]],
	[[2, 10]]
]

var current_wave_data = []
var current_wave: int = 0
var current_wave_position: int = 0

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	start_wave()

func start_wave() -> void:
	Global.wave_start.emit(current_wave + 1)
	wave_timer.stop()
	current_wave_data.clear()
	for enemy_data in waves[current_wave]:
		var enemy_type = enemy_data[0]
		var count = enemy_data[1]
		for i in count:
			current_wave_data.push_back(enemy_type)
	
	print(current_wave_data)
	current_wave_position = 0
	enemy_timer.start()

func spawn_enemy() -> void:
	if current_wave_position >= current_wave_data.size():
		enemy_timer.stop()
		
		if current_wave < waves.size() - 1:
			current_wave += 1
			wave_timer.start()
		
		return

	var current_enemy_type = current_wave_data[current_wave_position]

	var new_enemy: Enemy = enemy.instantiate()
	new_enemy.target = king
	new_enemy.position = enemy_spawn_point.global_position
	new_enemy.stats = enemy_type_resources[current_enemy_type].duplicate()
	add_child(new_enemy)

	current_wave_position += 1
