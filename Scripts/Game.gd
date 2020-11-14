extends Node2D

var player = preload("res://Scenes/Player.tscn")

var target_speed : float

var lines = []
var line_color = Color.white

func _ready():
	generate_lines()
	reset()
	
func _physics_process(delta):
	slowMo_actions()
	
func slowMo_actions():
	if Global.slow_motion_enabled:
		if Global.asset_base_speed < Global.slow_motion_speed_threshold:
			target_speed = Global.asset_base_speed * Global.slow_motion_strength
		else:
			target_speed = Global.slow_motion_speed
			
		Global.slow_motion_lerp_amount = (Global.asset_base_speed - target_speed) / 10000
		Global.asset_speed = lerp(Global.asset_speed, target_speed, Global.slow_motion_lerp_amount)
		change_background_color(Color.white)
		change_lines_colors(Color.black)
	else:
		Global.asset_speed = lerp(Global.asset_speed, Global.asset_base_speed, Global.slow_motion_lerp_amount)
		change_background_color(Color.black)
		change_lines_colors(Color.white)
	
	Global.base_spawn_time = Global.distance_between_enemies / Global.asset_speed

func generate_lines():
	for point in Global.points:
		var line_point = point - Global.first_point
		print("line_point: ", line_point)
		lines.append(generate_line(line_point))
		
	var last_line_x = Global.points[Global.point_amount - 1 ] + Global.first_point
	print("line_point: ", last_line_x)
	lines.append(generate_line(last_line_x))
	
func generate_line(x):
	var line = Line2D.new()
	
	line.default_color = line_color
	line.width = 5
	line.add_point(Vector2(x, -1000), -1)
	line.add_point(Vector2(x, Global.screen_height + 1000), -1)	
	add_child(line)

	return line
	
func change_background_color(target_color):
	if $Background.color == target_color:
		return
	$Background.color = lerp($Background.color, target_color, Global.slow_motion_lerp_amount)
	
func change_lines_colors(target_line_color):
	if line_color == target_line_color:
		return
	line_color = lerp(line_color, target_line_color, Global.slow_motion_lerp_amount)
	for line in lines:
		line.modulate = line_color
		
func reset():
	get_tree().paused = false
	remove_assets()
	camera_reset()
	speed_reset()
	Global.instance_node(player, Global.player_spawn_location, self)

func remove_assets():
	var asset_list = get_tree().get_nodes_in_group("Asset")
	if asset_list != null and asset_list.size() > 0:
		for asset in asset_list:
			asset.visible = false
			asset.queue_free()

func camera_reset():
	Global.camera.zoom_start = false
	Global.camera.global_position = Global.camera_base_position
	Global.camera.zoom = Vector2(1,1)
	
func speed_reset():
	Global.asset_base_speed = Global.asset_start_speed
	Global.asset_speed = Global.asset_base_speed
	Global.slow_motion_enabled = false
	Global.slow_motion_amount = 10
