extends KinematicBody2D

var speed = 400
var velocity = Vector2()
var spawn_position = Vector2()
# we rotate paddle slightly based on up or down movements
# this allows the ball to react similar to the original pong
# due to slightly altered impact angles using the kinematic2d
# "bounce" method.
func spawn(spawn_position):
	position = spawn_position

func delete():
	queue_free()

func get_input():
	# add these actions in Project Settings -> Input Map
	velocity = Vector2()
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
		$CollisionShape2D.set_rotation_degrees(4)
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
		$CollisionShape2D.set_rotation_degrees(-4)
	if velocity.y == 0:
		$CollisionShape2D.set_rotation_degrees(0)
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	var collision = move_and_collide(velocity * delta)