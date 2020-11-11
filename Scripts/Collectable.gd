extends Sprite

var speed = 0
var collectable_size : float = 0
var square_sprite_size = 256
var temp_speed

func _ready():
	collectable_size = Global.lane_width / 4
	var scale = collectable_size / square_sprite_size
	set_scale(Vector2(scale, scale))
	temp_speed = speed
	
func _physics_process(delta):
	#if Global.slow_motion_enabled:
	#	if speed < Global.slow_motion_speed_threshold:
			#global_position += Vector2.UP * speed * delta * Global.slow_motion_strength
	#		temp_speed = lerp(temp_speed, speed * Global.slow_motion_strength, 0.1)
	#	else:
			#global_position += Vector2.UP * Global.slow_motion_speed * delta
	#		temp_speed = lerp(temp_speed, Global.slow_motion_speed, 0.1)
		#print("temp_speed: ", temp_speed)
			
	#	global_position += Vector2.UP * temp_speed * delta
	#else:
	#	global_position += Vector2.UP * speed * delta
	
	global_position += Vector2.UP * Global.asset_speed * delta		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func set_speed(speed_param):
	speed = speed_param
	temp_speed = speed
	
func set_speed_slowMo(speed_param, temp_speed_param):
	speed = speed_param
	temp_speed = temp_speed_param 
