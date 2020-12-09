extends Sprite

signal player_died

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

onready var tween = get_node("Tween")

func _ready():
	game = get_parent()
	self.connect("player_died", game, "_on_player_died")
	Global.player = self
	player_size = Global.lane_width - (Global.lane_width / 2)
	var scale = player_size / square_sprite_size
	set_scale(Vector2(scale, scale))
	location_index = Global.spawn_index

func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		blood_particles_instance = Global.instance_node(blood_particles, global_position, get_parent())
		blood_particles_instance.initial_velocity = 2 * Global.asset_speed
		visible = false
		if Global.slow_motion_enabled:	
			area.get_parent().modulate = Color.black
		else:
			area.get_parent().modulate = Color.white
		emit_signal("player_died")
	if area.is_in_group("Collectable"):
		Global.slow_motion_amount += 1
		area.get_parent().queue_free()

func _on_SwipeDetector_swipe(swipe):
	if swipe == "right" and location_index < Global.point_amount - 1:
			target_position = Vector2(Global.points[location_index + 1], global_position.y)
			location_index += 1
	
	if swipe == "left" and location_index > 0:
			target_position = Vector2(Global.points[location_index - 1], global_position.y)
			location_index -= 1
			
	tween.interpolate_property(self, 'position', global_position, target_position, 0.06)
	tween.start()

func _on_SlowMotionTimer_timeout():
	if Global.slow_motion_enabled:
		Global.slow_motion_amount -= 1 
	if Global.slow_motion_amount == 0:
		Global.slow_motion_enabled = false
		
func stop_moving():
	if target_position != null:	
		global_position = target_position
	tween.stop_all()
	
func remove_blood_particle():
	blood_particles_instance.queue_free()
