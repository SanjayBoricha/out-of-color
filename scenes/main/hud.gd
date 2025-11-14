extends Control

@onready var wave_count: Label = %WaveCount

func _ready() -> void:
	Global.wave_count = wave_count
	Global.hud = self
