extends KinematicBody2D
# The directions our player can dash in.
var horiz = 0
var verti = 0

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
		horiz = clamp(horiz, -2, 0)
		verti = 0
		horiz -= 1
	elif(Input.is_action_just_pressed("ui_right")):
		amt.x = 1
		pressed = true
		verti = 0
		horiz = clamp(horiz, 0, 2)
		horiz += 1
	elif(Input.is_action_just_pressed("ui_up")):
		amt.y = -1
		pressed = true
		horiz = 0
		verti = clamp(verti, -2, 0)
		verti -= 1
	elif(Input.is_action_just_pressed("ui_down")):
		amt.y = 1
		pressed = true
		horiz = 0
		verti = clamp(verti, 0, 2)
		verti += 1
	
	if(pressed):
		$ChainTimer.start(0.5)
		amt = amt.normalized()
		vel += amt * 0.5
		
		# The dash capabilities are implemented here.
		vel.x *= 5 if abs(horiz) == 2 else 1
		vel.y *= 5 if abs(verti) == 2 else 1
		
		var dashing = abs(horiz) == 2 or abs(verti) == 2
		if(dashing):
			dash_reset()
			
		accel += amt * (0.6 if dashing else 1.5)



func dash_reset():
	horiz = 0
	verti = 0
