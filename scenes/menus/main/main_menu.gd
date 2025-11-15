extends Control

const cursor = preload("res://assets/images/ui/cursor.png")
const crosshair = preload("res://assets/images/ui/crosshair.png")

var music_audio_bus_id: int
var sfx_audio_bus_id: int

@onready var hover_sfx = $MouseHoverSFX
@onready var click_sfx = $MouseClickSFX
@onready var india_popup_menu: MarginContainer = $IndiaPopupMenu
@onready var us_popup_menu: MarginContainer = $UsPopupMenu
@onready var europe_popup_menu: MarginContainer = $EuropePopupMenu

func open_popup(country) -> void:
	match country:
		"us":
			us_popup_menu.visible = true
		"europe":
			europe_popup_menu.visible = true
		"india":
			india_popup_menu.visible = true

func close_all_popup() -> void:
	us_popup_menu.visible = false
	europe_popup_menu.visible = false
	india_popup_menu.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_audio_bus_id = AudioServer.get_bus_index("Music")
	sfx_audio_bus_id = AudioServer.get_bus_index("SFX")
	Input.set_custom_mouse_cursor(cursor)
	close_all_popup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	hover_sfx.play()
	Input.set_custom_mouse_cursor(crosshair)

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(cursor)

func _on_us_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left_click"):
		close_all_popup()
		click_sfx.play()
		open_popup("us")
	pass

func _on_europe_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left_click"):
		close_all_popup()
		click_sfx.play()
		open_popup("europe")
	pass

func _on_india_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left_click"):
		close_all_popup()
		click_sfx.play()
		open_popup("india")
	pass

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

func _on_close_panel_pressed() -> void:
	close_all_popup()

func _quit_game() -> void:
	get_tree().quit()
