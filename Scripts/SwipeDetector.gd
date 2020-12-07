extends Node

signal swipe

var swipe_start = null
var swipe_end = null
var swipe

var minimum_drag = 20

var position

func _input(event):
	position = event.get_position()
	#mouse_swipe(event)
	touch_swipe(event)
						
func mouse_swipe(event):
	if event.is_action_pressed("click"):
		swipe_start = event.get_position()
		$MovementTimer.start()
						
func touch_swipe(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			swipe_start = event.get_position()
			$MovementTimer.start()
					
func swipe_ended_action(swipe_start, swipe_end):
	swipe = swipe_end - swipe_start
	if abs(swipe.y) > abs(swipe.x):
		if swipe.y > 0 and !Global.slow_motion_enabled and Global.slow_motion_amount > 0:
			Global.slow_motion_enabled = true
		elif -swipe.y > minimum_drag and Global.slow_motion_enabled:
			Global.slow_motion_enabled = false
	else:
		if swipe.x > 0:
			emit_signal("swipe", "right")
		else:
			emit_signal("swipe", "left")
											
func _on_MovementTimer_timeout():
	swipe_end = position
	swipe_ended_action(swipe_start, swipe_end)
