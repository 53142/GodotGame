extends Node2D

@export var teleport_to := Vector2(0,0)

func _on_hitbox_area_entered(area):
	area.get_parent().position = teleport_to
