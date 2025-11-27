extends Control

const cursor = preload("res://assets/images/ui/cursor.png")
const crosshair = preload("res://assets/images/ui/crosshair.png")

var music_audio_bus_id: int
var sfx_audio_bus_id: int

@onready var hover_sfx = $MouseHoverSFX
@onready var click_sfx = $MouseClickSFX
@onready var volume_button: TextureButton = $MarginContainer/SoundOptions/Volume
@onready var sfx_button: TextureButton = $MarginContainer/SoundOptions/SFX
@onready var india_popup_menu: MarginContainer = $IndiaPopupMenu
@onready var us_popup_menu: MarginContainer = $UsPopupMenu
@onready var europe_popup_menu: MarginContainer = $EuropePopupMenu
@onready var africa_popup_menu: MarginContainer = $AfricaPopupMenu

func open_popup(country) -> void:
	match country:
		Global.map_keys["us"]:
			us_popup_menu.visible = true
		Global.map_keys["europe"]:
			europe_popup_menu.visible = true
		Global.map_keys["africa"]:
			africa_popup_menu.visible = true
		Global.map_keys["india"]:
			india_popup_menu.visible = true

func close_all_popup() -> void:
	us_popup_menu.visible = false
	europe_popup_menu.visible = false
	africa_popup_menu.visible = false
	india_popup_menu.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_audio_bus_id = AudioServer.get_bus_index("Music")
	sfx_audio_bus_id = AudioServer.get_bus_index("SFX")
	Input.set_custom_mouse_cursor(cursor)
	close_all_popup()
	if AudioServer.get_bus_volume_linear(music_audio_bus_id) == 0.0:
		volume_button.button_pressed = true

	if AudioServer.get_bus_volume_linear(sfx_audio_bus_id) == 0.0:
		sfx_button.button_pressed = true

	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	hover_sfx.play()
	Input.set_custom_mouse_cursor(crosshair)

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(cursor)

func _on_map_input_event(_viewport: Node, event: InputEvent, _shape_idx: int, country: String) -> void:
	if event.is_action_pressed("mouse_left_click"):
		close_all_popup()
		click_sfx.play()
		match country:
			Global.map_keys["us"]:
				open_popup(Global.map_keys["us"])
			Global.map_keys["europe"]:
				open_popup(Global.map_keys["europe"])
			Global.map_keys["africa"]:
				open_popup(Global.map_keys["africa"])
			Global.map_keys["india"]:
				open_popup(Global.map_keys["india"])

func _on_music_toggled(toggled_on: bool) -> void:
	click_sfx.play()
	if toggled_on:
		AudioServer.set_bus_volume_db(music_audio_bus_id, linear_to_db(0.0))
	else:
		AudioServer.set_bus_volume_db(music_audio_bus_id, linear_to_db(1.0))

func _on_sfx_toggled(toggled_on: bool) -> void:
	click_sfx.play()
	if toggled_on:
		AudioServer.set_bus_volume_db(sfx_audio_bus_id, linear_to_db(0.0))
	else:
		AudioServer.set_bus_volume_db(sfx_audio_bus_id, linear_to_db(1.0))

func _on_start_map(country: String):
	match country:
		Global.map_keys["us"]:
			Global.current_map = Global.map_keys["us"]
		Global.map_keys["europe"]:
			Global.current_map = Global.map_keys["europe"]
		Global.map_keys["africa"]:
			Global.current_map = Global.map_keys["africa"]
		Global.map_keys["india"]:
			Global.current_map = Global.map_keys["india"]
	SceneTransition.change_scene("res://scenes/main/main.tscn")

func _on_close_panel_pressed() -> void:
	close_all_popup()

func _quit_game() -> void:
	get_tree().quit()
