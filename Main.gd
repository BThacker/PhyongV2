extends Node2D
# main game logic will be stored here
export (PackedScene) var Ball
export (PackedScene) var BallRig
var ballPosition
var direction
var score1 = 0
var score2 = 0
var winner

func _ready():
	# generate new seeds for debug purposes
	randomize()
	# check current screen size, not sure if necessary
	ballPosition = get_viewport_rect().size / 2

# hackery to make the ball start randomly
func randomize_ball_direction(directions):
	return directions[randi() % directions.size()]

func add_ball():
	# as ball is a packed scene, we will instance the object in the world
	var b = Ball.instance()
	var direction1 = rand_range(140, 220)
	var direction2 = rand_range(0, 40)
	var direction3 = rand_range(320, 360)
	direction = randomize_ball_direction([direction1, direction2, direction3])
	b.start(ballPosition, direction)
	add_child(b)
	$HUD.update_alpha_player1(.1)
	$HUD.update_alpha_player2(.1)

# thinking about adding more complex logic here
func start_action():
	add_ball()

func _on_HUD_start_game():
	new_game()
	$HUD.update_score_player1(0)
	$HUD.update_score_player2(0) # Replace with function body.

func new_game():
	score1 = 0
	score2 = 0
	start_action()
	$Player2_AI.idle = false

func reset_after_score():
	yield(get_tree().create_timer(3), "timeout")
	start_action()

func game_over():
	print("game is over")
	if score1 > score2:
		winner = "Player 1"
	else:
		winner = "Player 2"
	$HUD.show_game_over(winner)
	$HUD.update_alpha_player1(1)
	$HUD.update_alpha_player2(1)

func _on_player2ScoreArea_player2scored():
	print("player 2 scored")
	score2 += 1
	$HUD.update_score_player2(score2)
	$HUD.update_alpha_player1(1)
	$HUD.update_alpha_player2(1)
	if score2 == 5:
		game_over()
	else:
		reset_after_score()

func _on_player1ScoreArea_player1scored():
	print("player 1 scored")
	score1 += 1
	$HUD.update_score_player1(score1)
	$HUD.update_alpha_player1(1)
	$HUD.update_alpha_player2(1)
	if score1 == 5:
		game_over()
	else:
		reset_after_score()
