extends Node
signal death_changed(deaths)
signal show_game_over

# Ensure to preload the Checkpoint script
const Checkpoint = preload("res://Scripts/Interactable/checkpoint.gd")
const StartLevel = preload("res://Interactable/startlevel.gd")
const Player = preload("res://Characters/player.gd")

var current_checkpoint : Checkpoint
var start_location : StartLevel
var deaths = 0
var player : Player
#var hud : HUD

var current_scene = null


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print(current_scene.name)
	#hud = get_node("/Main/HUD")

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.queue_free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	




func respawn_player():
	deaths+=1
	death_changed.emit(deaths)
	
	# Set max # of deaths
	if (deaths >= 5):
		game_over()
	
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.position = start_location.global_position

func start_game():
	player.start_game = true

func game_over():
	player.position = start_location.global_position
	current_checkpoint = null
	
	deaths = 0
	death_changed.emit(deaths)
	player.start_game = false
	
	show_game_over.emit()
	#hud.show_game_over()

func level_complete():
	current_checkpoint = null
	
	deaths = 0
	player.start_game = false
	_ready()
