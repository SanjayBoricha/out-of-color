extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var color_button: TextureButton = %ColorButton
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var panel_container: PanelContainer = $CanvasLayer/PanelContainer

enum Bullet {
	RED,
	GREEN,
	BLUE
}

var bullets = {
	Bullet.RED: load("res://assets/weapons/bullets/red_bullet.png"),
	Bullet.GREEN: load("res://assets/weapons/bullets/green_bullet.png"),
	Bullet.BLUE: load("res://assets/weapons/bullets/blue_bullet.png"),
}

var bulletScenes = {
	Bullet.RED: preload("res://scenes/weapons/bullets/red_bullet.tscn"),
	Bullet.GREEN: preload("res://scenes/weapons/bullets/green_bullet.tscn"),
	Bullet.BLUE: preload("res://scenes/weapons/bullets/blue_bullet.tscn"),
}

var current_bullet = Bullet.RED
var last_bullet = Bullet.RED

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
	print("ready")
	color_button.texture_normal = bullets[Bullet.RED]

	#color_button.icon = image

func _process(_delta):
	if not deployed:
		@warning_ignore("standalone_ternary")
		colliding() if $CollisionArea.has_overlapping_areas() else not_colliding()
	elif rotates:
		@warning_ignore("standalone_ternary")
		#print("current_target")
		#sprite_2d.look_at(current_target.position) if is_instance_valid(current_target) else try_get_closest_target()
		
	if current_bullet != last_bullet:
		color_button.texture_normal = bullets[current_bullet]
		last_bullet = current_bullet

func _draw():
	if draw_range:
		draw_circle(Vector2(0,0), attack_range, "3ccd50a9", false, 1, true)

func set_placeholder():
	modulate = Color("6eff297a")

func build():
	deployed = true
	modulate = Color.WHITE

func colliding():
	can_place = false
	modulate = Color("ff5c2990")

func not_colliding():
	can_place = true
	modulate = Color("6eff297a")

func _on_detection_area_area_entered(area):
	if deployed and not current_target:
		var area_parent = area.get_parent()
		if area_parent.is_in_group("enemy"):
			current_target = area.get_parent()

func _on_detection_area_area_exited(area):
	if deployed and current_target == area.get_parent():
		current_target = null
		try_get_closest_target()

func try_get_closest_target():
	if not deployed:
		return
	var closest = 1000
	var closest_area = null
	for area in $DetectionArea.get_overlapping_areas():
		var dist = area.position.distance_to(position)
		if dist < closest:
			closest = dist
			closest_area = area
	if closest_area:
		current_target = closest_area.get_parent()

func open_details_pane():
	canvas_layer.visible = true
	var viewport_pos = position
	panel_container.position = viewport_pos - Vector2(0, panel_container.size.y + 20) # show above
	print("open_details_pane")

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
	if is_instance_valid(current_target):
		#print("fire")
		var bulletScene: Resource = bulletScenes[current_bullet]
		var bullet: Node2D = bulletScene.instantiate()
		bullet.damage = damage
		bullet.speed = 400
		bullet.pierce = 1
		bullet.position = position
		bullet.target = current_target
		get_parent().add_child(bullet)
		#apply_scale(Vector2(1.1, 1.1))
		#await get_tree().create_timer(0.3).timeout
		#apply_scale(Vector2(1.0, 1.0))
	else:
		try_get_closest_target()


func _on_color_button_pressed() -> void:
	if current_bullet == Bullet.RED:
		current_bullet = Bullet.GREEN
	elif current_bullet == Bullet.GREEN:
		current_bullet = Bullet.BLUE
	elif current_bullet == Bullet.BLUE:
		current_bullet = Bullet.RED

func _input(event: InputEvent) -> void:
	if canvas_layer.visible and (event is InputEventMouseButton) and event.pressed:
		var local_pos = panel_container.get_local_mouse_position()
		if local_pos.x < 0 or local_pos.y < 0 or local_pos.x > panel_container.size.x or local_pos.y > panel_container.size.y:
			canvas_layer.visible = false
