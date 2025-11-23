class_name HurtComponent
extends Area2D

signal hurt
signal dot(dpt, duration)
signal freeze

func _on_area_entered(area: Area2D) -> void:
	if area is HitComponent:		
		hurt.emit(area.hit_damage)

		if area.dot:
			dot.emit(1, 5)

		if area.freeze:
			freeze.emit()

	if area.name == "Kingdom":
		print("enemy entered kingdom")
		await get_tree().create_timer(1.0).timeout
		get_parent().queue_free()
