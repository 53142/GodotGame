extends Node

@export var mob_scene: PackedScene
var score


func game_over():
	$ScoreTimer.stop()

func new_game():
	score = 0
	
func _ready():
	new_game()
	pass
