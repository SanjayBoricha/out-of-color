class_name SceneTransition
extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(target: String) -> void:
	print(animation_player)
	#animation_player.play('dissolve')
	#await animation_player.animation_finished
	#get_tree().change_scene(target)
	#animation_player.play_backwards('dissolve')
