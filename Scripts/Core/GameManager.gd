extends Node
signal death_changed(deaths)
signal score_changed(score)

signal show_game_over
signal advance_next_level

# Ensure to preload the Checkpoint script
const Checkpoint = preload("res://Scripts/Interactable/checkpoint.gd")
const StartLevel = preload("res://Interactable/startlevel.gd")
const Player = preload("res://Characters/player.gd")

var current_checkpoint : Checkpoint
var start_location : StartLevel
var player : Player

var deaths = 0
var score = 0

var current_level = null
var was_game_over = false

func respawn_player():
	deaths+=1
	death_changed.emit(deaths)
	
	# Set max # of deaths
	if (deaths >= player.max_lives):
		print("game_over")
		was_game_over = true
		game_over()
	
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.position = start_location.global_position


	# Disable player movement for 0.7 seconds
	if !was_game_over:
		player.start_game = false
		await get_tree().create_timer(0.7).timeout
		player.start_game = true
	else:
		was_game_over = false

func start_game():
	player.start_game = true

func game_over():
	player.position = start_location.global_position
	
	# Remove current checkpoint
	current_checkpoint = null
	
	
	# Set all checkpoints to deactivated
	for child in current_level.get_children():
		if child is Checkpoint:
			child.activated = false
		
	
	# Set all checkpoints to deactivated
	for child in current_level.get_children():
		if child is Coin:
			child.can_score = true
			child.show()


	deaths = 0
	score = 0
	
	
	# Update HUD
	death_changed.emit(deaths)
	score_changed.emit(score)
	player.start_game = false
	
	show_game_over.emit()

func level_complete():
	# Reset deaths
	#deaths = 0
	#death_changed.emit(deaths)
	# Reset score
	#score = 0
	#score_changed.emit(score)
	
	advance_next_level.emit()

func increment_score():
	score+=1
	score_changed.emit(score)
