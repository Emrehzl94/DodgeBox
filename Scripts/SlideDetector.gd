extends Node

var press_count = 0
var slide_start_point = null

func _input(event):
	return
	if event is InputEventScreenTouch:
		if event.is_pressed():
			press_count += 1
			if press_count == 2:
				slide_start_point = event.get_position()
				Global.is_sliding = true
		elif !event.is_pressed() and Global.is_sliding:
			Global.is_sliding = false

func _on_PressTimer_timeout():
	press_count = 0
