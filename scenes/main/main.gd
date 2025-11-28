extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var game_over: CanvasLayer = $GameOver
@onready var game_over_label: Label = %GameOverLabel
@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton
@onready var wave_survided_count: Label = %WaveSurvidedCount
@onready var kill_count: Label = %KillCount

@onready var pause_button: TextureButton = %PauseButton
@onready var game_paused: CanvasLayer = $GamePaused
@onready var resume_button: Button = %ResumeButton
@onready var main_menu_button: Button = %MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.main_node = self
	canvas_modulate.visible = Global.is_night

	var level: PackedScene = null
	if Global.current_map in Global.map_keys.keys():
		level = Global.maps[Global.current_map]
		add_child(level.instantiate())

	Global.max_enemies_entered.connect(_on_max_enemies_entered)
	restart_button.pressed.connect(_restart_game)
	quit_button.pressed.connect(_quit_game)
	Global.game_completed.connect(_on_game_complete)
	
	pause_button.pressed.connect(_on_game_paused)
	resume_button.pressed.connect(_on_game_resume)
	main_menu_button.pressed.connect(_quit_game)

func _draw() -> void:
	Global.reset_state()
	Global.add_to_points(35)
	get_tree().paused = false

func update_game_over_labels(won = false) -> void:
	game_over_label.text = "game over: you won" if won else "game over: you lost"
	wave_survided_count.text = "Total waves survived: " + str(Global.current_wave)
	kill_count.text = "Total kills: " + str(Global.killed_enemies)

func _on_max_enemies_entered() -> void:
	update_game_over_labels(false)
	get_tree().paused = true
	game_over.visible = true

func _on_game_complete() -> void:
	update_game_over_labels(true)
	get_tree().paused = true
	game_over.visible = true

func _restart_game() -> void:
	get_tree().reload_current_scene()

func _quit_game() -> void:
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://scenes/menus/main/main_menu.tscn")
	await get_tree().create_timer(0.1).timeout
	SceneTransition.change_scene("res://scenes/menus/main/main_menu.tscn")

func _on_game_paused() -> void:
	get_tree().paused = true
	game_paused.visible = true

func _on_game_resume() -> void:
	get_tree().paused = false
	game_paused.visible = false
