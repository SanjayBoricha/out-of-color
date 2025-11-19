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

func _process(delta: float) -> void:
	position += direction * stats.speed * delta

func _on_hit_component_area_entered(area: Area2D) -> void:
	if stats.aoe == false:
		queue_free()
