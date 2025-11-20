class_name Bullet
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_component: HitComponent = $HitComponent

@export var stats: BulletStats

var direction: Vector2

func _ready() -> void:
	sprite_2d.texture = stats.get_sprite_texture()
	hit_component.hit_damage = stats.damage
	hit_component.dot = stats.dot
	hit_component.freeze = stats.freeze
	
	if stats.aoe:
		await get_tree().create_timer(0.4).timeout
		queue_free()

func _process(delta: float) -> void:
	position += direction * stats.speed * delta

func _physics_process(delta: float) -> void:
	if stats.aoe:
		scale += delta * Vector2(20, 20)

func _on_hit_component_area_entered(area: Area2D) -> void:
	if stats.aoe == false:
		queue_free()
