extends CharacterBody2D

const movement_speed = 100.0

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var stats = EnemyStats

@export var target: Node = null

func _ready() -> void:
	$NavigationAgent2D.target_position = target.global_position
	add_to_group("enemy")
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)

func _physics_process(delta: float) -> void:
	if !$NavigationAgent2D.is_target_reached():
		var nav_point_direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = nav_point_direction * movement_speed
		move_and_slide()

func on_hurt(hit_damage: int) -> void:
	#print("hurt")
	damage_component.apply_damage(hit_damage)

func on_max_damage_reached() -> void:
	#print("max damage reached")
	queue_free()
