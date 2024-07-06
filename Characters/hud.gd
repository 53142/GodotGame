extends CanvasLayer
class_name HUD

signal start_game

func _ready():
	GameManager.death_changed.connect(_on_death_changed)
	GameManager.show_game_over.connect(_on_show_game_over)
	
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

func update_deaths(deaths):
	$DeathLabel.text = "Deaths: " + str(deaths)
	
func _on_start_button_pressed():
	$Message.hide()
	$StartButton.hide()
	#start_game.emit()
	GameManager.start_game()

func _on_message_timer_timeout():
	$Message.hide()
	
func _on_death_changed(deaths):
	update_deaths(deaths)
	
func _on_show_game_over():
	show_game_over()
