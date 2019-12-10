extends CanvasLayer

signal start_game_ai
signal start_game_2p
# to implement
signal start_game_multiplayer

func _ready():
	update_alpha_player1(0)
	update_alpha_player2(0)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over(winnerName):
	show_message("Game Over, " + winnerName + " Wins!")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Phyong!"
	$MessageLabel.show()
	update_score_player1(0)
	update_score_player2(0)
	yield(get_tree().create_timer(3), 'timeout')
	$StartButton_AI.show()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

# allows us to manipulate transparency during gameplay
func update_alpha_player1(alpha):
	$ScoreLabel1.modulate.a = alpha

func update_alpha_player2(alpha):
	$ScoreLabel2.modulate.a = alpha

func update_score_player1(score):
	$ScoreLabel1.text = str(score)
func update_score_player2(score):
	$ScoreLabel2.text = str(score)

func _on_StartButton_AI_button_up():
	$StartButton_AI.hide()
	$MessageLabel.hide()
	emit_signal("start_game_ai")
	print("start game")
	update_alpha_player1(.1)
	update_alpha_player2(.1)
