extends Node

enum EnemyTypes {
	CIRCLE,
	TRIANGLE,
	SQUARE,
}

signal wave_start(wave)

var selected_map := ""
var mainNode : Node2D
var turretsNode : Node2D
var projectilesNode : Node2D
var currentMap : Node2D
var hud : Control

var wave_count: Node = null

func _ready() -> void:
	wave_start.connect(on_wave_start)

func on_wave_start(wave) -> void:
	wave_count.text = "Wave: " + str(wave)

func restart_current_level():
	var currentLevelScene := load(currentMap.scene_file_path)
	currentMap.queue_free()
	var newMap = currentLevelScene.instantiate()
	newMap.map_type = selected_map
	mainNode.add_child(newMap)
	hud.reset()
