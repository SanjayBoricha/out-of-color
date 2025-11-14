extends TextureButton

@onready var audio_bus_id = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_volume_db(audio_bus_id, 0)
	else:
		AudioServer.set_bus_volume_db(audio_bus_id, 1)
