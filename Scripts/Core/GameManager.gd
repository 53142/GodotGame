extends Node
signal death_changed(deaths, max_deaths)
signal score_changed(score, max_score)

signal show_game_over
signal advance_next_level

# Preload scripts
const Checkpoint = preload("res://Scripts/Interactable/checkpoint.gd")
const StartLevel = preload("res://Scripts/Interactable/startlevel.gd")
const Player = preload("res://Characters/player.gd")

var current_checkpoint : Checkpoint
var start_location : StartLevel
var player : Player

var score = 0
var max_score = 0

var current_level = null
var was_game_over = false

func respawn_player():
	death_changed.emit(player.deaths, player.max_lives)
	
	# Set max # of deaths
	if (player.deaths >= player.max_lives):
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


	player.deaths = 0
	score = 0
	player.score = score
	
	
	# Update HUD
	death_changed.emit(player.deaths, player.max_lives)
	score_changed.emit(score, max_score)
	player.start_game = false
	
	show_game_over.emit()

func level_complete():
	# Reset deaths
	#player.deaths = 0
	#death_changed.emit(player.deaths)
	# Reset score
	#score = 0
	#score_changed.emit(score)
	
	advance_next_level.emit()

func increment_score():
	score+=1
	score_changed.emit(score, max_score)
	player.score = score

func reset_deaths():
	player.deaths = 0
	death_changed.emit(player.deaths, player.max_lives)

func save_game():
	print("saving game")
	var save_game = FileAccess.open("user://platformergame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)

func load_game():
	print("loading game")
	if not FileAccess.file_exists("user://platformergame.save"):
		print("error")
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects during loading
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		print("freeing")
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_game = FileAccess.open("user://platformergame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		print("filename: ", node_data["filename"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
		
		# Call _ready function if node has it
		if new_object.has_method("_ready"):
			new_object._ready()	
	# Update HUD
	death_changed.emit(player.deaths, player.max_lives)
	score_changed.emit(score, max_score)
