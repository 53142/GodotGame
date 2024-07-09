extends Node2D
class_name Coin

var can_score = true
var is_hidden = false

func _ready():
	if is_hidden:
		self.hide()

func _on_hitbox_area_entered(area):
	if area.get_parent() is Player and can_score:
		GameManager.increment_score()
		self.hide()
		is_hidden = true
		can_score = false

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"can_score" : can_score,
		"is_hidden" : is_hidden
		
		#maybe show if coin hidden?
	}
	return save_dict
