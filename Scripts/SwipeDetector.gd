extends Node

signal swipe
var swipe_start = null
var swipe_end = null
var minimum_drag = 50
var press_count = 0

func _input(event):
	mouse_swipe(event)
	#touch_swipe(event)
						
func mouse_swipe(event):
	if event.is_action_pressed("click"):
		swipe_start = event.get_position()
	if event.is_action_released("click"):
		swipe_end = event.get_position()
		var swipe = swipe_end - swipe_start
		if abs(swipe.x) > minimum_drag:
			if swipe.x > 0:
				emit_signal("swipe", "right")
			else:
				emit_signal("swipe", "left")
		else:
			print("slowMo")
			press_count += 1
			if press_count == 2:
				if Global.slow_motion_enabled:
					Global.slow_motion_enabled = false
				elif !Global.slow_motion_enabled and Global.slow_motion_amount > 0:
					Global.slow_motion_enabled = true
					press_count = 0
						
func touch_swipe(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			swipe_start = event.get_position()
		else:
			swipe_end = event.get_position()
			var swipe = swipe_end - swipe_start
			if abs(swipe.x) > minimum_drag:
				if swipe.x > 0:
					emit_signal("swipe", "right")
				else:
					emit_signal("swipe", "left")
			else:
				press_count += 1
				if press_count == 2:
					if Global.slow_motion_enabled:
						Global.slow_motion_enabled = false
					elif !Global.slow_motion_enabled and Global.slow_motion_amount > 0:
						Global.slow_motion_enabled = true
						press_count = 0
										
func _on_PressTimer_timeout():
	press_count = 0
