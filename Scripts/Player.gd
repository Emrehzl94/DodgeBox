extends Sprite

var game
var player_size : float = 0
var location_index
var square_sprite_size : float = 256

var is_moving = false

var target_position

var is_left = false
var is_right = false

var blood_particles = preload("res://Scenes/Blood_particles.tscn")
var blood_particles_instance

onready var game_over_panel = get_parent().get_node("CanvasLayer/GameUI/GameOver")

func _ready():
	game = get_parent()
	Global.player = self
	player_size = Global.lane_width - (Global.lane_width / 2)
	var scale = player_size / square_sprite_size
	set_scale(Vector2(scale, scale))
	location_index = Global.spawn_index
		
func _process(delta):
	#move_with_keyboard()
	move_with_swipe()
			
func _physics_process(delta):
	if is_moving:
		global_position = lerp(global_position, target_position, 0.5)
		if round(global_position.x) == (target_position.x):
			global_position = target_position
			is_moving = false
			is_right = false
			is_left = false
			
func move_with_keyboard():
	if Input.is_action_just_released("right") and location_index < Global.point_amount - 1:
			target_position = Vector2(Global.points[location_index + 1], global_position.y)
			is_moving = true
			location_index += 1
	
	if Input.is_action_just_released("left") and location_index > 0:
			target_position = Vector2(Global.points[location_index - 1], global_position.y)
			is_moving = true
			location_index -= 1
			
func move_with_swipe():
	if is_right and location_index < Global.point_amount - 1:
			target_position = Vector2(Global.points[location_index + 1], global_position.y)
			is_moving = true
			location_index += 1
			is_right = false
	
	if is_left and location_index > 0:
			target_position = Vector2(Global.points[location_index - 1], global_position.y)
			is_moving = true
			location_index -= 1
			is_left = false

func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		blood_particles_instance = Global.instance_node(blood_particles, global_position, get_parent())
		blood_particles_instance.initial_velocity = 2 * Global.asset_speed
		visible = false
		get_tree().paused = true
		if Global.slow_motion_enabled:	
			area.get_parent().modulate = Color.black
		else:
			area.get_parent().modulate = Color.white
		Global.camera.screen_shake(25, 0.6)
		yield(get_tree().create_timer(4), "timeout")
		game_over_panel.visible = true
	if area.is_in_group("Collectable"):
		Global.slow_motion_amount += 1
		area.get_parent().queue_free()

func _on_SwipeDetector_swipe(swipe):
	if swipe == "left":
		is_left = true
	elif swipe == "right":
		is_right = true

func _on_SlowMotionTimer_timeout():
	if Global.slow_motion_enabled:
		Global.slow_motion_amount -= 1 
	if Global.slow_motion_amount == 0:
		Global.slow_motion_enabled = false

func remove_blood_particle():
	blood_particles_instance.queue_free()
