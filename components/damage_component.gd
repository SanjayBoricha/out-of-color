class_name DamageComponent
extends Node2D

@export var max_damage: int = 1
@export var current_damage: int = 0

signal max_damage_reached
signal clear_dot

var status_effect := Global.StatusEffect.NONE

var dot_interval: float = 1.0
var dot_timer: Timer = null
var dot_damage = 0

var freeze: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dot_timer = Timer.new()
	dot_timer.wait_time = dot_interval
	dot_timer.one_shot = false
	dot_timer.connect("timeout", _apply_dot)
	add_child(dot_timer)

func apply_damage(damage: int) -> void:
	current_damage = clamp(current_damage + damage, 0, max_damage)
	
	if current_damage == max_damage:
		max_damage_reached.emit()

func apply_dot(damage_per_tick: int, duration: float):
	dot_timer.stop()
	
	dot_damage = damage_per_tick
	status_effect = Global.StatusEffect.DOT

	dot_timer.start()

	# Stop DoT after duration
	get_tree().create_timer(duration).connect("timeout", _stop_dot)

func _apply_dot() -> void:
	print("_apply_dot")
	if status_effect == Global.StatusEffect.DOT:
		apply_damage(dot_damage)

func _stop_dot():
	status_effect = Global.StatusEffect.NONE
	dot_timer.stop()
	clear_dot.emit()
