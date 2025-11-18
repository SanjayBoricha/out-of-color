extends Node

enum EnemyTypes {
	CIRCLE,
	TRIANGLE,
	SQUARE,
}

enum BulletType {
	RED,
	GREEN,
	BLUE,
}

enum StatusEffect {
	NONE,
	DOT,
	FREEZE,
}

signal wave_start(wave)
signal points_update(points)

var is_night: bool = false

var hud: Control
var main_node: Node2D
var current_map: Node2D
var selected_map: Node2D

var current_wave: int = 0
var current_points: int = 35

func wave_started(wave: int) -> void:
	current_wave = wave
	wave_start.emit(current_wave)

func add_to_points(points) -> void:
	current_points += points
	points_update.emit(current_points)

func use_points(points) -> void:
	current_points -= points
	points_update.emit(current_points)

func restart_current_level():
	var currentLevelScene := load(current_map.scene_file_path)
	current_map.queue_free()
	var new_map = currentLevelScene.instantiate()
	new_map.map_type = selected_map
	main_node.add_child(new_map)
	hud.reset()
