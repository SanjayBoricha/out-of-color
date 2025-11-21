extends TextureButton

const cursor = preload("res://assets/images/ui/cursor.png")
const cursor_disabled = preload("res://assets/images/ui/disabled.png")
const tool_pickaxe = preload("res://assets/images/ui/tool_pickaxe.png")

@onready var hover_sfx = $MouseHoverSFX
@onready var click_sfx = $MouseClickSFX

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var turrent_menu: Control = $TurrentMenu
@onready var children = turrent_menu.get_node("MarginContainer/TurrentContainer").get_children()

var turret = preload("res://scenes/weapons/turret.tscn")
var aoe_turret = preload("res://scenes/weapons/aoe_turret.tscn")

func _ready() -> void:
	var stylebox_normal_color = Color(0, 0, 0, 0.333)
	var stylebox_hover_color = Color(0, 0, 0, 0.459)
	if Global.is_night:
		stylebox_normal_color = Color(255, 255, 255, 0.333) 
		stylebox_hover_color = Color(255, 255, 255, 0.459) 

	for turrent in children:
		turrent["theme_override_styles/normal"].bg_color = stylebox_normal_color
		turrent["theme_override_styles/hover"].bg_color = stylebox_hover_color

	point_light_2d.visible = Global.is_night

func _physics_process(_delta: float) -> void:
	if Global.current_points >= 35:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 0.5)

func _on_pressed() -> void:
	if Global.current_points < 35:
		return
	turrent_menu.visible = true

func _input(event: InputEvent) -> void:
	if turrent_menu.visible and (event is InputEventMouseButton) and event.pressed:
		var local_pos = turrent_menu.get_local_mouse_position()
		if local_pos.x < 0 or local_pos.y < 0 or local_pos.x > turrent_menu.size.x or local_pos.y > turrent_menu.size.y:
			turrent_menu.visible = false

func _on_single_target_turret_pressed() -> void:
	var new_turret: Node2D = turret.instantiate()
	Global.main_node.add_child(new_turret)
	new_turret.position = self.position + Vector2(16, 16)
	queue_free()
	Global.use_points(35)

func _on_multi_target_turret_pressed() -> void:
	var new_turret: Node2D = aoe_turret.instantiate()
	Global.main_node.add_child(new_turret)
	new_turret.position = self.position + Vector2(16, 16)
	queue_free()
	Global.use_points(35)

func _on_mouse_entered() -> void:
	if Global.current_points < 35:
		Input.set_custom_mouse_cursor(cursor_disabled)
		return
	hover_sfx.play()
	Input.set_custom_mouse_cursor(tool_pickaxe)

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(cursor)
