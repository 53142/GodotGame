extends Node2D
class_name Main

var current_level = null
var current_index = null
var level_paths = [
	"res://Levels/1.tscn",
	"res://Levels/2.tscn",
	"res://Levels/3.tscn",
	"res://Levels/4.tscn"
]

const max_scores = [38, 38, 30, 0]



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
	print("Loading level: ", level_paths[index])
	var level_scene = ResourceLoader.load(level_paths[index])
	
	# Instance the level and add it to the scene tree
	current_level = level_scene.instantiate()
	#add_child(current_level)
	call_deferred("add_child", current_level)
	GameManager.current_level = current_level
	
	if index > 0:
		$HUD.show_start_screen()
	# Connect any signals from the level to the main script if needed

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
	var got_max_score = false
	if GameManager.score == max_scores[current_index]:
		got_max_score = true
	$HUD.show_final_score(GameManager.score, got_max_score)
	await get_tree().create_timer(2.0).timeout
	
	# Reset score and deaths
	GameManager.score = 0
	GameManager.reset_deaths()
	$HUD.update_score(GameManager.score)
	next_level()
