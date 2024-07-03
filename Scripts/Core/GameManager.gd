extends Node


# Ensure to preload the Checkpoint script
#const Checkpoint = preload("res://Scripts/Interactable/checkpoint.gd")


var current_checkpoint : Checkpoint
var score = 0
var player : Player
var hud : HUD


func _ready():
	hud = get_node("/root/TestLevel/HUD")

func respawn_player():
	score+=1
	hud.update_score(score)
	
	if (score >= 2):
		score = 0
		hud.update_score(score)
		get_node("/root/TestLevel/Player").start_game = false
		hud.show_game_over()
	
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func _on_hud_start_game():
	$Player.start_game = true
