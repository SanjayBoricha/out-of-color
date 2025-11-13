extends Control

@onready var wave_count: Label = %WaveCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.wave_count = wave_count


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
