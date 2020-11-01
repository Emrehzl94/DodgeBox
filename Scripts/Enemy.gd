extends Sprite

var speed = 200
var enemy_size : float = 0
var square_sprite_size = 256

func _ready():
	print("spawned")
	enemy_size = Global.lane_width - (Global.lane_width / 2)
	var scale = enemy_size / square_sprite_size
	set_scale(Vector2(scale, scale))

func _physics_process(delta):
	global_position += Vector2.UP * speed * delta
