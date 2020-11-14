extends Camera2D

var screen_shake_start = false
var shake_intensity = 0
var explosion_zoom = Vector2(0.6, 0.6)
var zoom_start = false

func _ready():
	global_position = Global.camera_base_position
	print("camera_position: " , global_position)
	Global.camera = self
	
func _physics_process(delta):
	if screen_shake_start:
		zoom = lerp(zoom, Vector2(1, 1), 0.05)
		global_position += Vector2(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity)) * delta
	
	if zoom_start:
		global_position = lerp(global_position, Global.player.global_position, 0.05)
		zoom = lerp(zoom, explosion_zoom, 0.05)

func screen_shake(shake_intensity_param, time):
	zoom = Vector2(1, 1) - Vector2(shake_intensity_param * 0.005, shake_intensity_param * 0.005)
	shake_intensity = shake_intensity_param
	$Screen_shake_time.wait_time = time
	$Screen_shake_time.start()
	screen_shake_start = true

func _on_Screen_shake_time_timeout():
	screen_shake_start = false
	global_position = Global.camera_base_position
	zoom_start = true
