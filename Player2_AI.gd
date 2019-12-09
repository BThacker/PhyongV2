extends KinematicBody2D

var speed = 400
var laser_color = Color( 0.55, 0, 0, 1 )
var target
var ball_pos = Vector2()
var velocity = Vector2()
var idle = true
var canMove = false
var _timer = null
var starting_position = Vector2()

func _ready():
	starting_position = position
	delay_response()

func _process(delta):
	if target:
		locate_ball()

func _physics_process(delta):
	move_and_collide(velocity * delta)
	update()
	decide_movement()
	if !target:
		return_to_mid()

func delay_response():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout",self, "_on_Timer_timeout")
	# how often we want the AI to respond to information
	_timer.set_wait_time(.15)
	_timer.set_one_shot(false)
	_timer.start()

func _on_Timer_timeout():
	if canMove:
		canMove = !canMove
		print(canMove)
		return
	if !canMove:
		canMove = true
		print(canMove)
		return

# based on what we see from the raytrace, we move up or down
func decide_movement():
	if !idle and canMove:
		velocity = Vector2()
		if ball_pos.y > position.y:
			velocity.y += 1
			$CollisionShape2D.set_rotation_degrees(4)
		if ball_pos.y < position.y:
			velocity.y -= 1
			$CollisionShape2D.set_rotation_degrees(-4)
		velocity = velocity.normalized() * speed

# basic logic to return to mid
func return_to_mid():
	velocity = Vector2()
	if canMove:
		if position.y > starting_position.y:
			velocity.y -= 1
		if position.y < starting_position.y:
			velocity.y += 1
		$CollisionShape2D.set_rotation_degrees(0)
		velocity = velocity.normalized() * speed

# visible used to verify we are tracking the ball correctly
func _draw():
	if target:
		draw_line(Vector2(), (ball_pos - position).rotated(-rotation), laser_color)

# we find and get the position of the ball consistently to make an AI decision
func locate_ball():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position,
                    [self], collision_mask)
	if result:
		ball_pos = result.position
