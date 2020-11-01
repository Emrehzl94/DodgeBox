extends Node2D

var player = preload("res://Scenes/Player.tscn")

func _ready():
	player = Global.instance_node(player, Global.player_spawn_location, self)
	

