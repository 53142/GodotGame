extends Node2D
class_name Main

var current_level = null
var current_index = null
var level_paths = [
	"res://Levels/test_level.tscn",
	"res://Levels/2.tscn",
	# Add more levels here
]


func _ready():
	load_level(0)  # Start with the first level
	GameManager.advance_next_level.connect(_on_advance_next_level)


func load_level(index):
	current_index = index
	
	
	if current_level != null:
		current_level.queue_free()
		current_level = null
	
	
	# Load the level scene
	print("Loading level: ", level_paths[index])
	var level_scene = ResourceLoader.load(level_paths[index])
	
	# Instance the level and add it to the scene tree
	current_level = level_scene.instantiate()
	add_child(current_level)
	
	# Connect any signals from the level to the main script if needed
	# current_level.connect("signal_name", self, "_on_signal_received")

func next_level():
	if current_level == null:
		print("No current level loaded.")
		return
	
	var next_index = current_index + 1
	if next_index < level_paths.size():
		load_level(next_index)
	else:
		print("No more levels!")

func _on_advance_next_level():
	next_level()
