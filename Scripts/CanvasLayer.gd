extends CanvasLayer
var fps
var fps_drop_counter = 0

func _physics_process(delta):
	fps = Performance.get_monitor(Performance.TIME_FPS)
	$Stat1.text = "FPS: " + str(fps)
	$Stat2.text = "MEMORY: " + str(Performance.get_monitor(Performance.MEMORY_STATIC)/1024/1024)
	if int(fps) < 50:
		fps_drop_counter += 1
		$Stat3.text = "FPS drop occurs " + str(fps_drop_counter)
