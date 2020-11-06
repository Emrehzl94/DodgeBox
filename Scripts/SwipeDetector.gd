extends Node

signal swipe
var swipe_start = null
var minimum_drag = 100

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			swipe_start = event.get_position()
		else:
			_calculate_swipe(event.get_position())
		
func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	print(swipe)
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			emit_signal("swipe", "right")
		else:
			emit_signal("swipe", "left")
