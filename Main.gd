extends Node2D
export (PackedScene) var Ball
export (PackedScene) var Player1
export (PackedScene) var Player2_AI

var ballPosition
var player1Position
var aiPosition
var direction
var score1 = 0
var score2 = 0
var winner
var p1_start_pos
var p2_start_pos
var current_p1
var current_p2
var current_ball
enum gameEntity{spawn, destroy}

func _ready():
	# generate new seeds for debug purposes
	randomize()
	# check current screen size, not sure if necessary
	ballPosition = get_viewport_rect().size / 2
	p1_start_pos = $player1POS.position
	p2_start_pos = $player2POS.position

# hackery to make the ball start randomly
func randomize_ball_direction(directions):
	return directions[randi() % directions.size()]

# spawning players, AI and ball
func ball(action):
	# as ball is a packed scene, we will instance the object in the world
	var b = Ball.instance()
	var direction1 = rand_range(140, 220)
	var direction2 = rand_range(0, 40)
	var direction3 = rand_range(320, 360)
	direction = randomize_ball_direction([direction1, direction2, direction3])
	if action == gameEntity.spawn:
		b.spawn(ballPosition, direction)
		add_child(b)
		$HUD.update_alpha_player1(.1)
		$HUD.update_alpha_player2(.1)
		current_ball = b
	if action == gameEntity.destroy:
		current_ball.queue_free()

func player_1(action):
	var player1 = Player1.instance()
	if action == gameEntity.spawn:
		player1.spawn(p1_start_pos)
		add_child(player1)
		current_p1 = player1
		print("Spawning Player 1")
	if action == gameEntity.destroy:
		current_p1.queue_free()

#func player_2(action):
#	player2.spawn(p2_start_pos)

func ai_player_2(action):
	var ai = Player2_AI.instance()
	if action == gameEntity.spawn:
		ai.spawn(p2_start_pos)
		add_child(ai)
		print("spawning AI")
		current_p2 = ai
	if action == gameEntity.destroy:
		current_p2.queue_free()

# listening for start calls
func _on_HUD_start_game_ai():
	score1 = 0
	score2 = 0
	player_1(gameEntity.spawn)
	ball(gameEntity.spawn)
	ai_player_2(gameEntity.spawn)
	$HUD.update_score_player1(0)
	$HUD.update_score_player2(0)
	$HUD.update_alpha_player1(0)
	$HUD.update_alpha_player2(0)
	print("start game AI")

# main game logic
func reset_after_score():
	yield(get_tree().create_timer(3), "timeout")
	ball(gameEntity.spawn)

func game_over():
	print("game is over")
	player_1(gameEntity.destroy)
	ai_player_2(gameEntity.destroy)
	ball(gameEntity.destroy)
	if score1 > score2:
		winner = "Player 1"
	else:
		winner = "Player 2"
	$HUD.show_game_over(winner)
	$HUD.update_alpha_player1(0)
	$HUD.update_alpha_player2(0)

func _on_player2ScoreArea_player2scored():
	print("player 2 scored")
	score2 += 1
	ball(gameEntity.destroy)
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
	ball(gameEntity.destroy)
	$HUD.update_score_player1(score1)
	$HUD.update_alpha_player1(1)
	$HUD.update_alpha_player2(1)
	if score1 == 5:
		game_over()
	else:
		reset_after_score()
