extends Area2D

func _on_ScoreArea_area_entered(area):
	if area.is_in_group("Enemy"):
		Global.score += 10
		
