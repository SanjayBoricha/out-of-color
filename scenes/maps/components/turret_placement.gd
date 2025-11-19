extends TextureButton

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var panel_container: PanelContainer = $CanvasLayer/PanelContainer

var turret = preload("res://scenes/weapons/tank.tscn")

func _ready() -> void:
	point_light_2d.visible = Global.is_night

func _physics_process(delta: float) -> void:
	if Global.current_points >= 35:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 0.5)

func _on_pressed() -> void:
	if Global.current_points < 35:
		return
	
	var new_turret: Node2D = turret.instantiate()
	Global.main_node.add_child(new_turret)
	new_turret.position = self.position + Vector2(16, 16)
	queue_free()
	Global.use_points(35)
