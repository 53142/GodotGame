extends CharacterBody2D
class_name Player
signal hit


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var start_game = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.player = self

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y=0
		# Cap velocity at 1000
		if velocity.y > 1000:
			velocity.y = 1000
			
	if start_game:
		# Debug keys
		#if Input.is_action_just_pressed("reset_deaths"):
		#	GameManager.deaths = 0
		#if Input.is_action_just_pressed("debug_next_level"):
		#	GameManager.level_complete()
		
		
		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
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
				velocity.y *= 0.9
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
	
	if position.y >= 650:
		die()
func die():
	GameManager.respawn_player()

func start_game_func():
	start_game = true
