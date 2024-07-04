extends Node2D

var activated = false

func activate():
	activated = true
	$AnimationPlayer.play("Activated")
	print("level finished")
	GameManager.goto_scene("res://Levels/2.tscn")
	GameManager.level_complete()

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !activated:
		activate()
