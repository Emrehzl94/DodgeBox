extends Node

var screen_width = 1080
var screen_height

var point_amount = 3
var points = []
var lane_width

var spawn_index
var player_spawn_location
var first_point
var camera = null
var player = null

var is_sliding = false

var slow_motion_enabled = false
var slow_motion_strength = 0.5
var slow_motion_amount = 10
var slow_motion_speed = 600
var slow_motion_speed_threshold = 1200
var slow_motion_lerp_amount : float = 0.05

var asset_start_speed : float = 800
var asset_base_speed : float = 800
var asset_speed

var base_spawn_time = 1
var distance_between_enemies : float = 250

var camera_base_position

var max_ad_watch_count = 5

var rng = RandomNumberGenerator.new()

func _ready():
	screen_height = get_viewport().size.y
	screen_width = get_viewport().size.x
	camera_base_position =  Vector2((Global.screen_width / 2), Global.screen_height / 2)
	calculate_points()
	spawn_index = rng.randi_range(0, Global.point_amount - 1)
	player_spawn_location = Vector2(Global.points[spawn_index],  (2 * screen_height) / 3)
	distance_between_enemies =  1.8 * Global.lane_width
	
func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func calculate_points():
	lane_width = screen_width / point_amount
	first_point = lane_width / 2
	points.append(first_point)
	
	for i in range(1, point_amount):
		points.append(first_point + (lane_width * i))
	
	print(points)
