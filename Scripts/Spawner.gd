extends Node2D

var enemy = preload("res://Scenes/Enemy.tscn")
var collectable = preload("res://Scenes/Collectable.tscn")

var rng = RandomNumberGenerator.new()

var spawn_index
var base_speed : float = 300
var base_time : float = 1
var distance_between_enemies : float = 250
var max_speed = 2000
var speed_increment = 5
var collectable_chance = 10

func _ready():
	distance_between_enemies =  1.2 * Global.lane_width
	$Spawn_timer.start()

func _on_Spawn_timer_timeout():
	spawn_index = rng.randi_range(0, Global.point_amount - 1)
	
	if rng.randi_range(1, 100) < collectable_chance:
		var instance_collectable = Global.instance_node(collectable, Vector2(Global.points[spawn_index], global_position.y), get_parent())
		instance_collectable.speed = base_speed
	else:
		var instance_enemy = Global.instance_node(enemy, Vector2(Global.points[spawn_index], global_position.y), get_parent())
		instance_enemy.speed = base_speed
	
	if Global.slow_motion_enabled:
		$Spawn_timer.wait_time = base_time / Global.slow_motion_strength
	else:
		$Spawn_timer.wait_time = base_time
	$Spawn_timer.start()
	if base_speed < max_speed:
		base_speed += speed_increment
	base_time = distance_between_enemies / base_speed
