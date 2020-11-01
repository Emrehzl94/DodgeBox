extends Node2D

var enemy = preload("res://Scenes/Enemy.tscn")
var rng = RandomNumberGenerator.new()
var spawn_index

func _on_Spawn_timer_timeout():
	spawn_index = rng.randi_range(0, Global.point_amount - 1)
	print("enemy_spawn_index: ", spawn_index)
	Global.instance_node(enemy, Vector2(Global.points[spawn_index], global_position.y), get_parent())
	$Spawn_timer.wait_time = 1
	$Spawn_timer.start()
