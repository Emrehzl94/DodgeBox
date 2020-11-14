extends Sprite

var speed = 0
var enemy_size : float = 0
var square_sprite_size = 256
var temp_speed

func _ready():
	enemy_size = Global.lane_width - (Global.lane_width / 2)
	var scale = enemy_size / square_sprite_size
	set_scale(Vector2(scale, scale))
	temp_speed = speed
	
func _process(delta):
	global_position += Vector2.DOWN * Global.asset_speed * delta

#func _physics_process(delta):
#		global_position += Vector2.DOWN * Global.asset_speed * delta		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
