extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hit_pos = Vector2()
var target
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ai_decision_body_entered(body):
	if target:
		return
	get_node("../Player2_AI").target = body

func _on_ai_decision_body_exited(body):
	if body == get_node("../Player2_AI").target:
		get_node("../Player2_AI").target = null