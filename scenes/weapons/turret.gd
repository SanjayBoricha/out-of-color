extends Node2D

const cursor = preload("res://assets/images/ui/cursor.png")
const crosshair = preload("res://assets/images/ui/crosshair.png")

@onready var hover_sfx = $MouseHoverSFX
@onready var click_sfx = $MouseClickSFX
@onready var turrent_building_sfx = $TurrentBuildingSFX

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D

@onready var turret_details: Control = $TurretDetails
@onready var panel_container: PanelContainer = $TurretDetails/PanelContainer

@export var button_group: ButtonGroup

enum Bullet {
	RED,
	GREEN,
	BLUE
}

var bulletScene = preload("res://scenes/weapons/bullet/bullet.tscn")

var bullets := {
	Bullet.RED: load("res://assets/weapons/bullets/red_bullet.png"),
	Bullet.GREEN: load("res://assets/weapons/bullets/green_bullet.png"),
	Bullet.BLUE: load("res://assets/weapons/bullets/blue_bullet.png"),
}

var bulletStats := {
	Bullet.RED: load("res://scenes/weapons/bullet/types/single_fireball.tres"),
	Bullet.GREEN: load("res://scenes/weapons/bullet/types/single_poison.tres"),
	Bullet.BLUE: load("res://scenes/weapons/bullet/types/single_freeze.tres"),
}

var current_bullet := Bullet.RED
var current_status_effect := Global.StatusEffect.NONE
var last_bullet := Bullet.RED

#Deploying
var deployed := true
var can_place := true
var draw_range := true

#Attacking
var rotates := true
var current_target = null


#Stats
var attack_speed := 1.0:
	set(value):
		attack_speed = value
		$AttackCooldown.wait_time = 1.0/value
var attack_range := 1.0:
	set(value):
		attack_range = value
		$DetectionArea/CollisionShape2D.shape.radius = value
var damage := 1.0
var turret_level := 1

func _ready() -> void:
	turrent_building_sfx.play()
	point_light_2d.visible = Global.is_night

func _process(_delta):
	if current_bullet != last_bullet:
		last_bullet = current_bullet

func _draw():
	if draw_range:
		draw_circle(Vector2(0,0), attack_range, "3ccd50a9", false, 1, true)

func _on_detection_area_area_entered(area):
	if deployed and not current_target:
		var area_parent = area.get_parent()
		
		if area_parent is Enemy:
			current_target = area.get_parent()

func _on_detection_area_area_exited(area):
	if deployed and current_target == area.get_parent():
		current_target = null
		try_get_closest_target()

func try_get_closest_target():
	if not deployed:
		return
	var closest = 10000
	var closest_area = null
	for area in $DetectionArea.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Enemy and (parent.damage_component.status_effect == Global.StatusEffect.NONE or parent.damage_component.status_effect != current_status_effect):
			var dist = area.position.distance_to(position)
			if dist < closest:
				closest = dist
				closest_area = area
	if closest_area:
		current_target = closest_area.get_parent()

func open_details_pane():
	turret_details.visible = true

func close_details_pane():
	draw_range = false
	queue_redraw()

func _on_collision_area_input_event(_viewport, _event, _shape_idx):
	if deployed and Input.is_action_just_pressed("mouse_left_click"):
		open_details_pane()

func upgrade_turret():
	turret_level += 1
	#for upgrade in Data.turrets[turret_type]["upgrades"].keys():
		#if Data.turrets[turret_type]["upgrades"][upgrade]["multiplies"]:
			#set(upgrade, get(upgrade) * Data.turrets[turret_type]["upgrades"][upgrade]["amount"])
		#else:
			#set(upgrade, get(upgrade) + Data.turrets[turret_type]["upgrades"][upgrade]["amount"])
	#turretUpdated.emit()

func attack():
	try_get_closest_target()

	if is_instance_valid(current_target):
		var newBulletStats: BulletStats = bulletStats[current_bullet].duplicate()
		
		if newBulletStats.dot > 0:
			current_status_effect = Global.StatusEffect.DOT
		elif newBulletStats.freeze:
			current_status_effect = Global.StatusEffect.FREEZE
		else:
			current_status_effect = Global.StatusEffect.NONE
		
		var bullet: Bullet = bulletScene.instantiate()
		bullet.stats = newBulletStats
		bullet.position = position
		bullet.direction = (current_target.position - position).normalized()
		get_parent().add_child(bullet)
		#if current_status_effect != Global.StatusEffect.NONE:
		current_target = null
	else:
		try_get_closest_target()


func _on_color_button_pressed() -> void:
	var button_pressed = button_group.get_pressed_button()
	match button_pressed.name:
		'red':
			current_bullet = Bullet.RED
		'blue':
			current_bullet = Bullet.BLUE
		'green':
			current_bullet = Bullet.GREEN

	var current_bullet_stats: BulletStats = bulletStats[current_bullet]

	if current_bullet_stats.dot > 0:
		current_status_effect = Global.StatusEffect.DOT
	elif current_bullet_stats.freeze:
		current_status_effect = Global.StatusEffect.FREEZE
	else:
		current_status_effect = Global.StatusEffect.NONE

	turret_details.visible = false

func _input(event: InputEvent) -> void:
	if turret_details.visible and (event is InputEventMouseButton) and event.pressed:
		var local_pos = panel_container.get_local_mouse_position()
		if local_pos.x < 0 or local_pos.y < 0 or local_pos.x > panel_container.size.x or local_pos.y > panel_container.size.y:
			turret_details.visible = false


var highlight_detection_area = false

func _on_collision_area_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(crosshair)
	highlight_detection_area = true
	$DetectionArea.queue_redraw()

func _on_collision_area_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(cursor)
	highlight_detection_area = false
	$DetectionArea.queue_redraw()

func _on_detection_area_draw() -> void:
	if highlight_detection_area:
		$DetectionArea.draw_circle(Vector2.ZERO, 100, Color("#ff000022"))

func _on_mouse_entered() -> void:
	hover_sfx.play()
	Input.set_custom_mouse_cursor(crosshair)

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(cursor)
