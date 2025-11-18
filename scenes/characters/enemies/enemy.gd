extends CharacterBody2D
class_name Enemy

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

@export var target: Node = null
@export var stats: EnemyStats

var agent : NavigationAgent2D

var status_effect := Global.StatusEffect.NONE

func _ready() -> void:
	agent = $NavigationAgent2D
	agent.avoidance_enabled = true
	
	if sprite_2d.material:
		sprite_2d.material = sprite_2d.material.duplicate()
	
	$NavigationAgent2D.target_position = target.global_position
	add_to_group("enemy")
	hurt_component.hurt.connect(on_hurt)
	hurt_component.dot.connect(on_dot)
	hurt_component.freeze.connect(on_freeze)
	damage_component.max_damage_reached.connect(on_max_damage_reached)
	damage_component.clear_status_effect.connect(on_clear_status_effect)
	sprite_2d.texture = stats.get_sprite_texture()
	damage_component.max_damage = stats.hp

func _physics_process(delta: float) -> void:
	if !$NavigationAgent2D.is_target_reached() and status_effect != Global.StatusEffect.FREEZE:
		var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = nav_point_direction * stats.speed
		keep_spacing()
		move_and_slide()

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)

func on_dot(dpt: int, duration: float) -> void:
	damage_component.apply_dot(dpt, duration)
	status_effect = Global.StatusEffect.DOT
	sprite_2d.material.set_shader_parameter("intensity", 0.6)

func on_freeze() -> void:
	status_effect = Global.StatusEffect.FREEZE

func on_clear_status_effect() -> void:
	status_effect = Global.StatusEffect.NONE
	sprite_2d.material.set_shader_parameter("intensity", 0.0)

func on_max_damage_reached() -> void:
	Global.add_to_points(stats.hp)
	queue_free()

func keep_spacing():
	var others = get_tree().get_nodes_in_group("enemies")

	for e in others:
		if e == self:
			continue

		var dist = global_position.distance_to(e.global_position)
		if dist < 20:   # pixels separation
			velocity += (global_position - e.global_position).normalized() * 50
