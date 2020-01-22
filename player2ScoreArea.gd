extends Area2D
signal player2scored

func _on_player2ScoreArea_body_entered(body):
	emit_signal("player2scored")
