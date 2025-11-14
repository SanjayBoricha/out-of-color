extends CharacterBody2D
class_name Enemy

const movement_speed = 100.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

@export var stats: Resource

@export var target: Node = null

func _ready() -> void:
	$NavigationAgent2D.target_position = target.global_position
	add_to_group("enemy")
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)
	sprite_2d.texture = stats.get_sprite_texture()
	damage_component.max_damage = stats.hp

func _physics_process(delta: float) -> void:
	if !$NavigationAgent2D.is_target_reached():
		var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = nav_point_direction * stats.speed
		move_and_slide()

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)

func on_max_damage_reached() -> void:
	queue_free()
