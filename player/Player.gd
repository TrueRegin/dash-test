extends KinematicBody2D
var up = 0
var down = 0
var left = 0
var right = 0

var vel = Vector2()
var accel = Vector2()

func _process(delta):
	self.move_and_collide(vel)
	vel += accel
	vel *= 0.88
	accel *= 0.95
	if(accel.length() < 0.01): accel = Vector2.ZERO
	
	handle_input()

func handle_input():
	var amt = Vector2()
	var pressed = false
	
	if(Input.is_action_just_pressed("ui_left")):
		amt.x = -1
		pressed = true
		left += 1
	if(Input.is_action_just_pressed("ui_right")):
		amt.x = 1
		pressed = true
		right += 1
	if(Input.is_action_just_pressed("ui_up")):
		amt.y = -1
		pressed = true
		up += 1
	if(Input.is_action_just_pressed("ui_down")):
		amt.y = 1
		pressed = true
		down += 1
	
	if(pressed):
		$ChainTimer.start(0.5)
		amt = amt.normalized()
		vel += amt * 0.5
		
		# The dash capabilities are implemented here.
		vel.x *= 3 if left == 2 or right == 2 else 1
		vel.y *= 3 if up == 2 or down == 2 else 1
		
		var dashing = up == 2 or down == 2 or left == 2 or right == 2
		if(dashing):
			dash_reset()
			
		accel += amt * (0.3 if dashing else 1.5)



func dash_reset():
	up = 0
	down = 0
	left = 0
	right = 0
