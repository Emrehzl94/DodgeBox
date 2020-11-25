extends Node2D

var enemy = preload("res://Scenes/Enemy.tscn")
var collectable = preload("res://Scenes/Collectable.tscn")

var instance_collectable
var instance_enemy

var rng = RandomNumberGenerator.new()

var spawn_index

var max_speed = 2000
var speed_increment = 2
var collectable_chance = 5
var multiple_spawn_chance = 20
var spawn_idexes: = []

var parent

func _ready():
	parent = get_parent()
	$Spawn_timer.start()

func _on_Spawn_timer_timeout():
	spawn_idexes = []
	spawn_idexes.append(rng.randi_range(0, Global.point_amount - 1))
	if rng.randi_range(1, 100) < multiple_spawn_chance:
		spawn_idexes.append(rng.randi_range(0, Global.point_amount - 1))
		
	if Global.slow_motion_amount < 20 and rng.randi_range(1, 100) < collectable_chance:
		Global.instance_node(collectable, Vector2(Global.points[spawn_idexes[0]], global_position.y), parent)
	else:
		for spawn_index in spawn_idexes:
			Global.instance_node(enemy, Vector2(Global.points[spawn_index], global_position.y), parent)

	$Spawn_timer.wait_time = Global.base_spawn_time
	$Spawn_timer.start()
	if Global.asset_base_speed < max_speed:
		Global.asset_base_speed += speed_increment
