extends Node

signal swipe

var swipe_start = null
var swipe_end = null
var swipe

var minimum_drag = 50
var minimum_drag_x = 50
var minimum_drag_y = 150
var press_count = 0

func _input(event):
	mouse_swipe(event)
	#touch_swipe(event)
						
func mouse_swipe(event):
	if event.is_action_pressed("click"):
		swipe_start = event.get_position()
	if event.is_action_released("click"):
		swipe_end = event.get_position()
		swipe = swipe_end - swipe_start
		if abs(swipe.y) > minimum_drag or abs(swipe.x) > minimum_drag:
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
				
#		if swipe.y > minimum_drag_y and !Global.slow_motion_enabled and Global.slow_motion_amount > 0:
#			Global.slow_motion_enabled = true
#		elif -swipe.y > minimum_drag_y and Global.slow_motion_enabled:
#			Global.slow_motion_enabled = false
#		elif abs(swipe.x) > minimum_drag_x:
#			if swipe.x > 0:
#				emit_signal("swipe", "right")
#			else:
#				emit_signal("swipe", "left")
						
func touch_swipe(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			swipe_start = event.get_position()
		else:
			swipe_end = event.get_position()
			swipe = swipe_end - swipe_start
			if abs(swipe.y) > minimum_drag or abs(swipe.x) > minimum_drag:
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
											
#func touch_swipe(event):
#	if event is InputEventScreenTouch:
#		if event.is_pressed():
#			swipe_start = event.get_position()
#		else:
#			swipe_end = event.get_position()
#			swipe = swipe_end - swipe_start
#			if abs(swipe.x) > minimum_drag_x:
#				if swipe.x > 0:
#					emit_signal("swipe", "right")
#				else:
#					emit_signal("swipe", "left")
#			else:
#				press_count += 1
#				if press_count == 2:
#					if Global.slow_motion_enabled:
#						Global.slow_motion_enabled = false
#					elif !Global.slow_motion_enabled and Global.slow_motion_amount > 0:
#						Global.slow_motion_enabled = true
#						press_count = 0
