extends Node
signal gameOver


# Ensure to preload the Checkpoint script
const Checkpoint = preload("res://Scripts/Interactable/checkpoint.gd")


var current_checkpoint : Checkpoint
var score = 0
var player : Player
var start_game = false


func _ready():
	new_game()

func respawn_player():
	score+=1
	
	if (score >= 10):
		game_over()
	
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position


func game_over():
	print("1")
	gameOver.emit()

func new_game():
	score = 0
	
	if start_game:
		pass


func _on_hud_start_game():
	print("here")
	start_game = true
