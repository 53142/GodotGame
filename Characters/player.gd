extends CharacterBody2D
class_name Player
signal hit


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var start_game = false
var deaths = 0
var score = 0
var curTilemap : TileData



@export var max_lives := 5
@export var min_position_y := 250

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.score = score
	print(score)
	# fix bug with score always resetting to 0 even if had score when loading save
	GameManager.player = self
	print("Max lives: ", max_lives)

func _physics_process(delta):
	if is_on_lava():
		die()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y=0
		# Cap velocity at 1000
		if velocity.y > 1500:
			velocity.y = 1500
			
	if start_game:
		# Debug keys
		if Input.is_action_just_pressed("reset_deaths"):
			deaths = 0
		if Input.is_action_just_pressed("debug_next_level"):
			GameManager.level_complete()
		
		
		if Input.is_action_just_pressed("save_game"):
			GameManager.save_game()
			
		if Input.is_action_just_pressed("load_game"):
			GameManager.load_game()
		
		# Handle jump
		if (Input.is_action_just_pressed("jump") || Input.is_action_just_pressed("jump(arrow)")) && is_on_floor():
			velocity.y = JUMP_VELOCITY


		# Get the input direction and handle the movement/deceleration.
		
		var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
		var direction2 = Input.get_action_strength("right(arrow)") - Input.get_action_strength("left(arrow)")
		
		if abs(direction2) > abs(direction):
			direction = direction2
		
		if direction:
			if !Input.is_action_pressed("move_slower"):
				velocity.x = direction * SPEED
			else:
				velocity.x = direction * SPEED * 0.3
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	
	if position.y >= min_position_y:
		die()
func die():
	deaths+=1
	GameManager.respawn_player()

func start_game_func():
	start_game = true



func getTileBelowPlayer() -> TileData:
	# FIX LATER
	# print(curTilemap)
	if !curTilemap:
		return null
	
	var localMapPos: Vector2 = curTilemap.to_local(global_position)
	var tilePos: Vector2i = curTilemap.local_to_map( localMapPos )
	return curTilemap.get_cell_tile_data(0, tilePos)


func is_on_lava() -> bool:
	var tileData: TileData = getTileBelowPlayer()
	if tileData == null:
		return false
	if tileData.get_custom_data(&"kill_on_touch") == true:
		return true
	return false


func save():
	print("save score: ", score)
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"speed" : SPEED,
		"jump_velocity" : JUMP_VELOCITY,
		"start_game" : start_game,
		"max_lives" : max_lives,
		"deaths" : deaths,
		"score" : score
	}
	return save_dict
