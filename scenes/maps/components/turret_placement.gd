extends TextureButton

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var panel_container: PanelContainer = $CanvasLayer/PanelContainer

var turret = preload("res://scenes/weapons/turret.tscn")
var aoe_turret = preload("res://scenes/weapons/aoe_turret.tscn")

func _ready() -> void:
	point_light_2d.visible = Global.is_night
	panel_container.position = position + Vector2(-20, -40)

func _physics_process(delta: float) -> void:
	if Global.current_points >= 35:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 0.5)

func _on_pressed() -> void:
	if Global.current_points < 35:
		return
	canvas_layer.visible = true

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
