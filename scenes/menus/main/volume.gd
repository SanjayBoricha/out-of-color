extends TextureButton

var audio_bus_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index("Music")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_volume_db(audio_bus_id, linear_to_db(0.0))
	else:
		AudioServer.set_bus_volume_db(audio_bus_id, linear_to_db(1.0))
