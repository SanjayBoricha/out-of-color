class_name HurtComponent
extends Area2D

signal hurt

func _on_area_entered(area: Area2D) -> void:
	if area is HitComponent:
		hurt.emit(area.hit_damage)
	
	if area.name == "Kingdom":
		print("enemy entered kingdom")
		await get_tree().create_timer(1.0).timeout
		hurt.emit(100)
