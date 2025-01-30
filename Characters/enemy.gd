extends CharacterBody2D
var speed = -30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speed_fast := true
@export var speed_really_fast := false
var facing_right = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2D.is_colliding() && is_on_floor() || is_on_wall():
		flip()
	
	velocity.x=speed

	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1


func _on_hitbox_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().die()

func _ready():
	if facing_right:
		speed = 30
	else:
		speed = -30

	if speed_fast:
		speed*= 2
		
	if speed_really_fast:
		speed*=2


# fix bug with enemies falling off map
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"speed" : speed,
		"speed_fast" : speed_fast,
		"facing_right" : facing_right
	}
	return save_dict
