extends CharacterBody2D
class_name Enemy

#@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var death_particles: CPUParticles2D = $CPUParticles2D

@export var target: Node = null
@export var stats: EnemyStats

var agent : NavigationAgent2D

var status_effects := []

func _ready() -> void:
	add_to_group("enemy")
	
	agent = $NavigationAgent2D
	agent.avoidance_enabled = true
	
	#if sprite_2d.material:
		#sprite_2d.material = sprite_2d.material.duplicate()
	
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	
	$NavigationAgent2D.target_position = target.global_position
	hurt_component.hurt.connect(on_hurt)
	hurt_component.dot.connect(on_dot)
	hurt_component.freeze.connect(on_freeze)
	damage_component.max_damage_reached.connect(on_max_damage_reached)
	damage_component.clear_dot.connect(on_clear_dot)
	#sprite_2d.texture = stats.get_sprite_texture()
	animated_sprite_2d.play(stats.get_sprite_animation())
	damage_component.max_damage = stats.hp

func _physics_process(_delta: float) -> void:
	if !$NavigationAgent2D.is_target_reached() :
		var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = nav_point_direction * (stats.speed / 4 if status_effects.has(Global.StatusEffect.FREEZE) else stats.speed)
		keep_spacing()
		move_and_slide()

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)

func on_dot(dpt: int, duration: float) -> void:
	damage_component.apply_dot(dpt, duration)
	status_effects.append(Global.StatusEffect.DOT)
	#sprite_2d.material.set_shader_parameter("intensity", 0.6)
	animated_sprite_2d.material.set_shader_parameter("intensity", 0.6)

func on_clear_dot() -> void:
	status_effects.remove_at(status_effects.bsearch(Global.StatusEffect.DOT))
	#sprite_2d.material.set_shader_parameter("intensity", 0.0)
	animated_sprite_2d.material.set_shader_parameter("intensity", 0.0)

func on_freeze() -> void:
	#print("on_freeze")
	status_effects.append(Global.StatusEffect.FREEZE)

func on_unfreeze() -> void:
	status_effects.remove_at(status_effects.bsearch(Global.StatusEffect.FREEZE))

func on_max_damage_reached() -> void:
	Global.add_to_points(stats.hp)
	die()

func keep_spacing():
	var others = get_tree().get_nodes_in_group("enemy")

	for e in others:
		if e == self:
			continue

		var dist = global_position.distance_to(e.global_position)
		if dist < 20:   # pixels separation
			velocity += (global_position - e.global_position).normalized() * 50


func die():
	#sprite_2d.visible = false
	animated_sprite_2d.visible = false
	death_particles.emitting = true
	await get_tree().create_timer(death_particles.lifetime + 0.1).timeout
	queue_free()
