extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_us_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/map_1/map_1.tscn")

func _on_europe_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/map_2/map_2.tscn")

func _on_india_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/map_3/map_3.tscn")
