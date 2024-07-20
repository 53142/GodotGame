extends Node2D
signal advance_next_level

var activated = false


func activate():
	activated = true
	$AnimationPlayer.play("Activated")
	#GameManager.goto_scene("res://Levels/2.tscn")
	#GameManager.level_complete()
	
	# Advance to next level
	#advance_next_level.emit()
	GameManager.level_complete()
	
func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !activated:
		activate()

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"activated" : activated
	}
	return save_dict
