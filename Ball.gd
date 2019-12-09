extends KinematicBody2D

var speed = 800
var velocity = Vector2()

func _ready():
	pass

func start(pos, dir):
	position = pos
	velocity = Vector2(speed, 0).rotated(deg2rad(dir))
	rotation = velocity.angle()
	print("ball is alive")

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		rotation = velocity.angle()
		if collision.collider.has_method("hit"):
			collision.collider.hit()
		if collision.collider.name == "Player1" or collision.collider.name == "Player2_AI" :
			$contact.play()