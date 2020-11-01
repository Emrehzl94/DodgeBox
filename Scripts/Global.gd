extends Node

var point_amount = 5
var points = []
var screen_width = 1080
var lane_width
var spawn_index
var player_spawn_location 

var rng = RandomNumberGenerator.new()

func _ready():
	calculate_points()
	spawn_index = rng.randi_range(0, Global.point_amount - 1)
	player_spawn_location = Vector2(Global.points[spawn_index], 200)
	
func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func calculate_points():
	lane_width = screen_width / point_amount
	var first_point = lane_width / 2
	points.append(first_point)
	
	for i in range(1, point_amount):
		points.append(first_point + (lane_width * i))
	
	print(points)
