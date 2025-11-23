extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var game_over: CanvasLayer = $GameOver
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.main_node = self
	canvas_modulate.visible = Global.is_night
	
	Global.max_enemies_entered.connect(_on_max_enemies_entered)
	
	restart_button.pressed.connect(_restart_game)
	quit_button.pressed.connect(_quit_game)

func _draw() -> void:
	get_tree().paused = false
	Global.use_points(Global.current_points)
	Global.add_to_points(35)

func _on_max_enemies_entered() -> void:
	get_tree().paused = true
	game_over.visible = true

func _restart_game() -> void:
	get_tree().reload_current_scene()

func _quit_game() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main/main_menu.tscn")
