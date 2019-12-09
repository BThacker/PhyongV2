extends KinematicBody2D

var speed = 800
var velocity = Vector2()

func start(pos, dir):
	position = pos
	velocity = Vector2(speed, 0).rotated(deg2rad(dir))
	rotation = velocity.angle()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		rotation = velocity.angle()
		# the simplest of sound integrations
		if collision.collider.name == "Player1" or collision.collider.name == "Player2_AI" :
			$contact.play()