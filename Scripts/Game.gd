extends Node2D

var player = preload("res://Scenes/Player.tscn")
var player_instance

var target_speed : float

var lines = []
var line_color = Color.white
var background_color = Color.black

var ad_watch_count
var count_down_counter = 3
var count_down_counter_started = false

onready var game_over_panel = get_node("CanvasLayer/GameUI/GameOver")
onready var watch_ad_button = get_node("CanvasLayer/GameUI/GameOver/VBoxContainer/WatchAdButton")
onready var count_down_counter_label = get_node("CanvasLayer/GameUI/CountDownCounter")
onready var score_label = get_node("CanvasLayer/GameUI/Score/ScoreLabel")
onready var slow_motion_bar = get_node("CanvasLayer/GameUI/SlowMotionBar")
onready var pause_button = get_node("CanvasLayer/GameUI/PauseButton")

var pause_icon = load("res://Sprites/pause.png")
var play_icon = load("res://Sprites/play.png")

func _ready():
	generate_lines()
	reset()
	
func _physics_process(delta):
	game_actions()
	
func game_actions():
	if Global.slow_motion_enabled:
		if Global.asset_base_speed < Global.slow_motion_speed_threshold:
			target_speed = Global.asset_base_speed * Global.slow_motion_strength
		else:
			target_speed = Global.slow_motion_speed
			
		Global.slow_motion_lerp_amount = (Global.asset_base_speed - target_speed) / 10000
		Global.asset_speed = lerp(Global.asset_speed, target_speed, Global.slow_motion_lerp_amount)
		change_background_color(Color.white)
		change_lines_colors(Color.black)
		if $WorldEnvironment.environment.is_glow_enabled():
			$WorldEnvironment.environment.set_glow_enabled(false)	
		score_label.modulate = Color.black
		pause_button.modulate = Color.black
	else:
		Global.asset_speed = lerp(Global.asset_speed, Global.asset_base_speed, Global.slow_motion_lerp_amount)
		change_background_color(Color.black)
		change_lines_colors(Color.white)
		if !$WorldEnvironment.environment.is_glow_enabled():
			$WorldEnvironment.environment.set_glow_enabled(true)
		score_label.modulate = Color.white
		pause_button.modulate = Color.white
		
	Global.base_spawn_time = Global.distance_between_enemies / Global.asset_speed
	
	score_label.text = str(Global.score)
	slow_motion_bar.value = Global.slow_motion_amount

func generate_lines():
	for point in Global.points:
		var line_point = point - Global.first_point
		lines.append(generate_line(line_point))
		
	var last_line_x = Global.points[Global.point_amount - 1 ] + Global.first_point
	print("line_point: ", last_line_x)
	lines.append(generate_line(last_line_x))
	
func generate_line(x):
	var line = Line2D.new()
	
	line.default_color = line_color
	line.width = 5
	line.add_point(Vector2(x, -1000), -1)
	line.add_point(Vector2(x, Global.screen_height + 1000), -1)	
	add_child(line)

	return line
	
func change_background_color(target_color):
	if background_color == target_color:
		return
	background_color = lerp(background_color, target_color, Global.slow_motion_lerp_amount)
	$Background.color = background_color
	
func change_lines_colors(target_line_color):
	if line_color == target_line_color:
		return
	line_color = lerp(line_color, target_line_color, Global.slow_motion_lerp_amount)
	for line in lines:
		line.modulate = line_color
		
func reset():
	watch_ad_button.disabled = false
	ad_watch_count = 0
	game_over_panel.visible = false
	count_down_counter_label.visible = false
	pause_button.disabled = false
	$Background.color = Color.black
	remove_assets()
	camera_reset()
	speed_reset()
	player_instance = Global.instance_node(player, Global.player_spawn_location, self)
	if Global.high_score < Global.score:
		Global.save_highscore()
	Global.score = 0
	get_tree().paused = false
	
func continue_game():
	game_over_panel.visible = false
	camera_reset()
	player_instance.visible = true
	player_instance.remove_blood_particle()
	player_instance.stop_moving()
	ad_watch_count += 1
	start_countdown()

func remove_assets():
	var asset_list = get_tree().get_nodes_in_group("Asset")
	if asset_list != null and asset_list.size() > 0:
		for asset in asset_list:
			asset.queue_free()

func camera_reset():
	Global.camera.zoom_start = false
	Global.camera.global_position = Global.camera_base_position
	Global.camera.zoom = Vector2(1,1)
	
func speed_reset():
	Global.asset_base_speed = Global.asset_start_speed
	Global.asset_speed = Global.asset_base_speed
	Global.slow_motion_enabled = false
	Global.slow_motion_amount = 10
	
func start_countdown():
	if Global.slow_motion_enabled:
		count_down_counter_label.modulate = Color.black
	else:
		count_down_counter_label.modulate = Color.white
	count_down_counter_label.visible = true
	count_down_counter_label.text = str(count_down_counter)
	$CountDownTimer.start()
	count_down_counter_started = true

func _on_WatchAdButton_pressed():
	if ad_watch_count < Global.max_ad_watch_count:
		continue_game()
		
func _on_RestartButton_pressed():
	reset()
		
func _on_CountDownTimer_timeout():
	if count_down_counter_started and count_down_counter != 0:
		count_down_counter -= 1
		if count_down_counter == 0:
			count_down_counter_label.visible = false
			pause_button.disabled = false
			get_tree().paused = false
			count_down_counter = 3
			count_down_counter_started = false
		else:
			count_down_counter_label.text = str(count_down_counter)
			$CountDownTimer.start()

func _on_GameOver_visibility_changed():
	if ad_watch_count == Global.max_ad_watch_count:
		watch_ad_button.disabled = true
		
func _on_player_died():
	get_tree().paused = true
	pause_button.disabled = true
	Global.camera.screen_shake(25, 0.6)
	yield(get_tree().create_timer(3), "timeout")
	game_over_panel.visible = true
	
func _on_PauseButton_pressed():
	if !get_tree().paused:
		pause_button.icon = play_icon
		get_tree().paused = true
	else:
		pause_button.icon = pause_icon
		start_countdown()
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if Global.high_score < Global.score:
			Global.save_highscore()
		get_tree().quit()
	
