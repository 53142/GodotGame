extends Node

var current_checkpoint : Checkpoint
var score = 0
var player : Player

func respawn_player():
	score+=1
	HUD.updateScore(score)
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
