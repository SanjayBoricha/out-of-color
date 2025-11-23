class_name Bullet
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_component: HitComponent = $HitComponent
@onready var normal_bullet_fire_sfx: AudioStreamPlayer2D = $NormalBulletFireSFX
@onready var aoe_fire_sfx: AudioStreamPlayer2D = $AoeBulletFireSFX
@onready var collision_shape_2d: CollisionShape2D = $HitComponent/CollisionShape2D
@onready var collision_polygon_2d: CollisionPolygon2D = $HitComponent/CollisionPolygon2D

@export var stats: BulletStats

var direction: Vector2

func _ready() -> void:
	sprite_2d.texture = stats.get_sprite_texture()
	hit_component.hit_damage = stats.damage
	hit_component.dot = stats.dot
	hit_component.freeze = stats.freeze
	hit_component.aoe = stats.aoe

	if stats.aoe:
		aoe_fire_sfx.play()
		await get_tree().create_timer(0.4).timeout
		queue_free()
	else:
		normal_bullet_fire_sfx.play()
		$Sprite2D.scale = Vector2(0.75, 0.75)
		$HitComponent/CollisionShape2D.scale = Vector2(0.75, 0.75)
	
func _draw() -> void:
	rotation = atan2(direction.y, direction.x) + PI/2
	
	if stats.aoe:
		collision_shape_2d.disabled = true
	else:
		collision_polygon_2d.disabled = true

func _process(delta: float) -> void:
	position += direction * stats.speed * delta

func _physics_process(delta: float) -> void:
	if stats.aoe:
		scale += delta * Vector2(12, 12)

func _on_hit_component_area_entered(_area: Area2D) -> void:
	if stats.aoe == false:
		queue_free()

func _on_draw() -> void:
	if stats.type == Global.BulletType.RED:
		$Fireball.visible = true
