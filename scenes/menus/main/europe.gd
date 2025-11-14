extends CollisionPolygon2D

const cursor = preload("res://assets/images/ui/cursor.png")
const crosshair = preload("res://assets/images/ui/crosshair.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_europe_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left_click"):
		print("europe shape pressed ", shape_idx)
	pass

func _on_europe_map_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(crosshair)


func _on_europe_map_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(cursor)
