extends Node2D

var enemy = preload("res://scenes/characters/enemies/enemy.tscn")

@onready var king: CharacterBody2D = %King
@onready var enemy_spawn_point: CollisionShape2D = %EnemySpawnPoint
@onready var enemy_timer: Timer = $EnemyTimer
@onready var next_wave_canvas: CanvasLayer = $NextWaveCanvas
@onready var next_wave_label: Label = $NextWaveCanvas/PanelContainer/NextWaveLabel

var enemy_type_resources: Array[EnemyStats] = [
	load("res://scenes/characters/enemies/types/circle.tres"),
	load("res://scenes/characters/enemies/types/triangle.tres"),
	load("res://scenes/characters/enemies/types/square.tres")
]

var waves = [
	[[0, 6]],
	[[0, 8]],
	[[1, 8],   [2, 2]],
	[[1, 10],  [2, 3]],
	[[1, 10],  [2, 4]],
	[[1, 12],  [2, 4]],
	[[1, 10],  [2, 6]],
	[[1, 9],   [2, 7]],
	[[1, 8],   [2, 8]],
	[[1, 7],   [2, 9]],
	[[1, 6],   [2, 10]],
	[[1, 6],   [2, 12]],
	[[1, 5],   [2, 14]],
	[[1, 4],   [2, 15]],
	[[1, 3],   [2, 16]],
	[[1, 3],   [2, 18]],
	[[1, 2],   [2, 20]],
	[[1, 2],   [2, 22]],
	[[1, 1],   [2, 24]],
	[[2, 28]]
]

var spawned_enemies: int = 0

var current_wave_data = []
var current_wave: int = 0
var current_wave_position: int = 0

func ordinal(n: int) -> String:
	var last_two = n % 100
	if last_two in [11, 12, 13]:
		return str(n) + "th"

	match n % 10:
		1:
			return str(n) + "st"
		2:
			return str(n) + "nd"
		3:
			return str(n) + "rd"
		_:
			return str(n) + "th"

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	start_wave()
	Global.enemy_killed.connect(on_enemy_killed_or_entered)
	Global.enemy_entered.connect(on_enemy_killed_or_entered)

func show_next_wave_canvas() -> void:
	next_wave_label.text = ordinal(current_wave + 1) + " wave incoming"
	
	var tween = get_tree().create_tween()
	tween.tween_property(next_wave_canvas, "offset", Vector2(0, 0), 0.5)
	tween.tween_interval(1)
	tween.chain().tween_property(next_wave_canvas, "offset", Vector2(-1200, 0), 0.5)
	tween.chain().tween_property(next_wave_canvas, "offset", Vector2(1200, 0), 0)

func start_wave() -> void:
	show_next_wave_canvas()
	await get_tree().create_timer(2.0).timeout
	
	current_wave_data.clear()
	for enemy_data in waves[current_wave]:
		var enemy_type = enemy_data[0]
		var count = enemy_data[1]
		for i in count:
			current_wave_data.push_back(enemy_type)
	
	current_wave_position = 0
	enemy_timer.start()
	Global.wave_started(current_wave + 1)

func spawn_enemy() -> void:
	if current_wave_position >= current_wave_data.size():
		enemy_timer.stop()
		
		if current_wave < waves.size():
			current_wave += 1
		
		return

	var current_enemy_type = current_wave_data[current_wave_position]

	var new_enemy: Enemy = enemy.instantiate()
	new_enemy.target = king
	new_enemy.position = enemy_spawn_point.global_position
	new_enemy.stats = enemy_type_resources[current_enemy_type].duplicate()
	add_child(new_enemy)
	spawned_enemies += 1

	current_wave_position += 1

func on_enemy_killed_or_entered() -> void:
	if (Global.entered_enemies + Global.killed_enemies) == spawned_enemies:
		print("wave cleared")
		await get_tree().create_timer(1.0).timeout
		
		if current_wave == waves.size():
			Global.game_completed.emit()
		else:
			start_wave()
