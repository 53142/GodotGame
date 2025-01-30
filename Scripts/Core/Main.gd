extends Node2D
class_name Main

var current_level = null
var current_index = null
var level_paths = [
	"res://Levels/1.tscn",
	"res://Levels/2.tscn",
	"res://Levels/3.tscn",
	"res://Levels/4.tscn",
	"res://Levels/5.tscn"
]

const max_scores = [38, 38, 30, 20, 14]

func _ready():
	load_level(0)  # Start with the first level
	GameManager.advance_next_level.connect(_on_advance_next_level)

func load_level(index):
	current_index = index
	
	if current_level != null:
		print("Freeing current level: ", current_level)
		current_level.queue_free()
		current_level = null
	
	# Load the level scene
	print("Loading level: ", level_paths[current_index])
	var level_scene = ResourceLoader.load(level_paths[current_index])
	
	# Instance the level and add it to the scene tree
	current_level = level_scene.instantiate()
	#add_child(current_level)
	call_deferred("add_child", current_level)
	GameManager.current_level = current_level
	GameManager.max_score = max_scores[current_index]
	$HUD.update_score(GameManager.score, GameManager.max_score)
	$HUD.update_deaths(0, 0)

	#if current_index == 0:
		#$HUD.show_start_screen()
	$HUD.show_start_screen()

func next_level():
	var next_index = current_index + 1
	if next_index < level_paths.size():
		load_level(next_index)
	else:
		print("No more levels!")
		$HUD.show_finish_game()
		# Load the first level again
		load_level(0)

func _on_advance_next_level():
	var got_max_score = GameManager.score == GameManager.max_score
	$HUD.show_final_score(GameManager.score, got_max_score)
	await get_tree().create_timer(2.0).timeout

	# Reset score and deaths
	GameManager.score = 0
	GameManager.max_score = max_scores[current_index]
	GameManager.reset_deaths()
	$HUD.update_score(GameManager.score, GameManager.max_score)
	next_level()
