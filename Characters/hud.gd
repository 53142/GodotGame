extends CanvasLayer
class_name HUD

func _ready():
	GameManager.death_changed.connect(_on_death_changed)
	GameManager.score_changed.connect(_on_score_changed)
	
	GameManager.show_game_over.connect(_on_show_game_over)
	

# Just used to always if statement
func _physics_process(delta):
	if Input.is_action_just_pressed("enter"):
		$Message.hide()
		$StartButton.hide()
		GameManager.start_game()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_start_screen():
	$Message.text = "Get to the end of the course while avoiding the enemies"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout
	show_start_screen()
	
func show_finish_game():
	$Message.text = "You won!"
	$Message.show()
	await get_tree().create_timer(2.0).timeout
	$StartButton.show()
	await get_tree().create_timer(1.0).timeout

func update_deaths(deaths):
	$DeathLabel.text = "Deaths: " + str(deaths)

func _on_start_button_pressed():
	$Message.hide()
	$StartButton.hide()
	GameManager.start_game()

func _on_message_timer_timeout():
	$Message.hide()
	
func _on_death_changed(deaths):
	update_deaths(deaths)
	
func _on_show_game_over():
	show_game_over()

func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)
	
func _on_score_changed(score):
	update_score(score)
	
func show_final_score(score, got_max_score):
	$Message.show()
	if got_max_score:
		$Message.text = "You got the max score: " + str(score) + "/" + str(score) + "!"
	else:
		$Message.text = "You got a score of: " + str(score)
