extends Node2D

var player = preload("res://Scenes/Player.tscn")
var line_color = Color(1, 1, 1)

func _ready():
	player = Global.instance_node(player, Global.player_spawn_location, self)
	get_tree().paused = false
	
func _draw():
	for point in Global.points:
		var line_point = point - Global.first_point
		draw_line(Vector2(line_point, -500), Vector2(line_point, 2 * get_viewport().size.y), line_color)

	var last_line = Global.points[Global.point_amount - 1 ] + Global.first_point + 1 
	draw_line(Vector2(last_line, -500), Vector2(last_line, 2 * get_viewport().size.y), line_color)
