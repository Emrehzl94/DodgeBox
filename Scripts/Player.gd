extends Sprite

var player_size : float = 0
var location_index
var square_sprite_size : float = 256

var is_moving = false

var target_position

func _ready():
	player_size = Global.lane_width - (Global.lane_width / 2)
	var scale = player_size / square_sprite_size
	set_scale(Vector2(scale, scale))
	location_index = Global.spawn_index
		
func _process(delta):
	if Input.is_action_just_released("right") and location_index < Global.point_amount - 1:
			print("right")
			target_position = Vector2(Global.points[location_index + 1], global_position.y)
			is_moving = true
			location_index += 1
	
	if Input.is_action_just_released("left") and location_index > 0:
			print("left")
			target_position = Vector2(Global.points[location_index - 1], global_position.y)
			is_moving = true
			location_index -= 1
			
func _physics_process(delta):
	if is_moving:
		#print("is_moving")
		global_position = lerp(global_position, target_position, 0.5)
		if round(global_position.x) == (target_position.x):
			global_position = target_position
			is_moving = false
