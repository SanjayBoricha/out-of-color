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

signal wave_start(wave: int)
signal points_update(points: int)
signal max_enemies_entered
signal game_completed
signal enemy_killed
signal enemy_entered

const map_keys = {
	"us": "us",
	"europe": "europe",
	"africa": "africa",
	"india": "india",
}

const maps = {
	"us": preload("res://scenes/maps/map_1/map_1.tscn"),
	"europe": preload("res://scenes/maps/map_2/map_2.tscn"),
	"africa": preload("res://scenes/maps/grass/grass_map.tscn"),
	"india": preload("res://scenes/maps/map_3/map_3.tscn"),
}

var is_night: bool = false

var hud: Control
var main_node: Node2D
var current_map: String

var current_wave: int = 0
var current_points: int = 0

var entered_enemies: int = 0
var max_entered_enemies: int = 5
var killed_enemies: int = 0
var killed_enemies_set := {}

func wave_started(wave: int) -> void:
	current_wave = wave
	wave_start.emit(current_wave)

func add_to_points(points: int) -> void:
	current_points += points
	points_update.emit(current_points)

func use_points(points: int) -> void:
	current_points -= points
	points_update.emit(current_points)

func increment_enemy_entered() -> void:
	entered_enemies += 1
	if entered_enemies >= max_entered_enemies:
		max_enemies_entered.emit()
	enemy_entered.emit()

func o7(enemy_id: int) -> void:
	killed_enemies_set[enemy_id] = true
	killed_enemies = killed_enemies_set.keys().size()
	enemy_killed.emit()
