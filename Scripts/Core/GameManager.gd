extends Node


# Ensure to preload the Checkpoint script
const Checkpoint = preload("res://Scripts/Interactable/checkpoint.gd")
const StartLevel = preload("res://Interactable/startlevel.gd")


var current_checkpoint : Checkpoint
var start_location : StartLevel
var deaths = 0
var player : Player
var hud : HUD


func _ready():
	hud = get_node("/root/TestLevel/HUD")

func respawn_player():
	deaths+=1
	hud.update_deaths(deaths)
	
	# Set max # of deaths
	if (deaths >= 5):
		game_over()
	
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.position = start_location.global_position

func _on_hud_start_game():	
	$Player.start_game = true

func game_over():
	player.position = start_location.global_position
	current_checkpoint = null
	
	deaths = 0
	hud.update_deaths(deaths)
	#get_node("/root/TestLevel/Player").start_game = false
	player.start_game = false
	hud.show_game_over()
