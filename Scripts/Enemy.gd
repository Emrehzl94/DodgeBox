extends Sprite

var speed = 0
var enemy_size : float = 0
var square_sprite_size = 256

func _ready():
	enemy_size = Global.lane_width - (Global.lane_width / 2)
	var scale = enemy_size / square_sprite_size
	set_scale(Vector2(scale, scale))

func _physics_process(delta):
	if Global.slow_motion_enabled:
		global_position += Vector2.UP * speed * delta * Global.slow_motion_strength
	else:
		global_position += Vector2.UP * speed * delta 
		
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
