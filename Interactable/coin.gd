extends Node2D
class_name Coin

var can_score = true

func _on_hitbox_area_entered(area):
	if area.get_parent() is Player and can_score:
		GameManager.increment_score()
		self.hide()
		can_score = false
