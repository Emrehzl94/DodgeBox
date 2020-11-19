extends Control

var fps

onready var fps_label = get_node("Fps")
onready var memory_label = get_node("Memory")

func _physics_process(delta):
	fps = Performance.get_monitor(Performance.TIME_FPS)
	fps_label.text = "FPS: " + str(fps)
	memory_label.text = "MEMORY: " + str(Performance.get_monitor(Performance.MEMORY_STATIC)/1024/1024)

