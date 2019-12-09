extends Area2D
signal player1scored

func _on_player1ScoreArea_body_entered(body):
	emit_signal("player1scored")