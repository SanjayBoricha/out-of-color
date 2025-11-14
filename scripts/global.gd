extends Node

enum EnemyTypes {
	CIRCLE,
	TRIANGLE,
	SQUARE,
}

signal wave_start(wave)

var selected_map := ""
var turretsNode : Node2D
var projectilesNode : Node2D
var currentMap : Node2D


var hud: Control
var wave_count: Label = null
var main_node: Node2D
var map_node: Node2D

func _ready() -> void:
	wave_start.connect(on_wave_start)

func on_wave_start(wave) -> void:
	wave_count.text = "Wave: " + str(wave)

func restart_current_level():
	var currentLevelScene := load(currentMap.scene_file_path)
	currentMap.queue_free()
	var new_map = currentLevelScene.instantiate()
	new_map.map_type = selected_map
	main_node.add_child(new_map)
	hud.reset()
