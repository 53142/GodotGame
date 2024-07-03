extends Node

var current_checkpoint : Checkpoint
var score = 0
var player : Player
var start_game = false



func respawn_player():
	score+=1
	
	if (score > 10):
		game_over()
	
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position


func game_over():
	$ScoreTimer.stop()

func new_game():
	score = 0
	
	if start_game:
		pass
	
func _ready():
	new_game()

func _on_hud_start_game():
	start_game = true
