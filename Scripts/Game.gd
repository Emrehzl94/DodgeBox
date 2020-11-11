extends Node2D

var player = preload("res://Scenes/Player.tscn")
var line_color = Color.white
var target_speed

func _ready():
	player = Global.instance_node(player, Global.player_spawn_location, self)
	get_tree().paused = false
	Global.asset_speed = Global.asset_base_speed
		
func _physics_process(delta):
	slowMo_actions()
	
func _draw():
	for point in Global.points:
		var line_point = point - Global.first_point
		draw_line(Vector2(line_point, -500), Vector2(line_point, 2 * get_viewport().size.y), line_color)

	var last_line = Global.points[Global.point_amount - 1 ] + Global.first_point + 1 
	draw_line(Vector2(last_line, -500), Vector2(last_line, 2 * get_viewport().size.y), line_color)
	
func slowMo_actions():
	if Global.slow_motion_enabled:
		if Global.asset_base_speed < Global.slow_motion_speed_threshold:
			target_speed = Global.asset_base_speed * Global.slow_motion_strength
		else:
			target_speed = Global.slow_motion_speed
		
		Global.slow_motion_lerp_amount = (Global.asset_base_speed - target_speed) / 10000
		Global.asset_speed = lerp(Global.asset_speed, target_speed, Global.slow_motion_lerp_amount)
		$Background.color = lerp($Background.color, Color.white, Global.slow_motion_lerp_amount)
	else:
		Global.asset_speed = lerp(Global.asset_speed, Global.asset_base_speed, Global.slow_motion_lerp_amount)
		$Background.color = lerp($Background.color, Color.black, Global.slow_motion_lerp_amount)
	
	Global.base_spawn_time = Global.distance_between_enemies / Global.asset_speed
