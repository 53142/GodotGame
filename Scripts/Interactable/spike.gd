extends Node2D

func _on_hitbox_area_entered(area):
	if area.get_parent() is Player:
			area.get_parent().die()

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	return save_dict
