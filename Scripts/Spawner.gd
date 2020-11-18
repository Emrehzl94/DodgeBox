extends Node2D

var enemy = preload("res://Scenes/Enemy.tscn")
var collectable = preload("res://Scenes/Collectable.tscn")

var instance_collectable
var instance_enemy

var rng = RandomNumberGenerator.new()

var spawn_index

var max_speed = 2000
var speed_increment = 2
var collectable_chance = 10

var parent

func _ready():
	parent = get_parent()
	$Spawn_timer.start()

func _on_Spawn_timer_timeout():
	spawn_index = rng.randi_range(0, Global.point_amount - 1)
		
	if rng.randi_range(1, 100) < collectable_chance:
		instance_collectable = Global.instance_node(collectable, Vector2(Global.points[spawn_index], global_position.y), parent)
	else:
		instance_enemy = Global.instance_node(enemy, Vector2(Global.points[spawn_index], global_position.y), parent)

	$Spawn_timer.wait_time = Global.base_spawn_time
	$Spawn_timer.start()
	if Global.asset_base_speed < max_speed:
		Global.asset_base_speed += speed_increment
