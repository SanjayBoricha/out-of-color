extends CollisionPolygon2D

const cursor = preload("res://assets/images/ui/cursor.png")
const crosshair = preload("res://assets/images/ui/crosshair.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_us_input_event(_viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left_click"):
		print("us shape pressed ", shape_idx)
	pass


func _on_us_map_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(crosshair)


func _on_us_map_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(cursor)
