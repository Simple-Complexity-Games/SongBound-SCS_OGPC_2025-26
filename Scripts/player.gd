extends CharacterBody2D

#Constants for Movement/Jump
const ACCELERATION_SPEED = 35
const PASSIVE_ACCEL_AIR = 2 #Used for acceleration while you walk
const DECELERATON_SPEED = 20 #Used to slow you down while you're walking
const DECELERATON_SPEED_AIR = 0.005
const ACCELERATION_AIR = 30 #Used for changing direction in midair, same with line 7
const ACCELERATION_FLYING = 20
const GROUND_SPEED = 200.0
const AIR_SPEED = 180
const JUMP_VELOCITY = -400.0
const MAX_JUMPS = 2 #Max jumps, read the name
const MAX_GLIDE_SPEED = 380
const MIN_GLIDE_SPEED = 40
const MAX_FALL_SPEED = 415
const GLIDE_ACCELERATION = 12

#Variables for Movement/Jump
var Total_Jumps = 0 #Total amount of jumps you've done
var Jumping = false #Tells us if were jumping
var Gliding = false #Makes it so you can't jump while gliding
var Gliding_Speed = 100
var Flying = false


#Variables for Coyote Time
var on_ground_checker = false
var coyote_time = false
var coyote_jump_timer = SceneTreeTimer
var coyote_seconds = 0.15


func _physics_process(delta: float) -> void:
	#Variables for _physics_process
	var direction := Input.get_axis("Move_Left", "Move_Right") #For left and right movement. 
	
	# Add the gravity.
	if not is_on_floor() and not Gliding and velocity.y < MAX_FALL_SPEED:
		velocity += get_gravity() * delta
	
	if is_on_floor():
		Total_Jumps = 0 #Resetting the double jumps
		Gliding = false #Turns off gliding
		Jumping = false
		Flying = false
	
	
	#Coyote timer code
	if not is_on_floor() and on_ground_checker: 
		coyote_jump_timer = get_tree().create_timer(coyote_seconds, false, true)
		coyote_jump_timer.timeout.connect(coyote_timer_done.bind())
		coyote_time = true
		on_ground_checker = false
	elif is_on_floor():
		on_ground_checker = true
		Jumping = false
		
	#Start of Jumping Code
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote_time) and not Gliding and Total_Jumps < MAX_JUMPS and not Flying:
		velocity.y = JUMP_VELOCITY
		Jumping = true
		Total_Jumps += 1
	elif Input.is_action_just_pressed("Jump") and Total_Jumps < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		Total_Jumps += 1
	elif Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = velocity.y / 5
	
	
	# All this is commented out for the time being. Till I know how to make it unlock later. 
	#Gliding 
	if Input.is_action_pressed("Gliding") and not is_on_floor() and not Gliding: #Turns on Gliding
		Gliding = true
	elif Input.is_action_just_released("Gliding") and Gliding:
		Gliding = false
	
	
	if Gliding:
		velocity.y = move_toward(velocity.y, (((MIN_GLIDE_SPEED - MAX_GLIDE_SPEED)/AIR_SPEED) * (abs(velocity.x) - AIR_SPEED) + MIN_GLIDE_SPEED), GLIDE_ACCELERATION)
	
	#Start of Flying Code
	#if not is_on_floor() and not Flying and Input.is_action_just_pressed("Flying"): #Activting flight ability
		#Flying = true
	#elif Flying and Input.is_action_just_pressed("Flying"): #Deactiving Flight Ability
		#Flying = false
	
	#if Flying:
		#velocity.y = move_toward(velocity.y, (((MIN_GLIDE_SPEED - MAX_GLIDE_SPEED)/SPEED) * (abs(velocity.x) - SPEED) + MIN_GLIDE_SPEED), GLIDE_ACCELERATION)
		#if Input.is_action_just_pressed("Jump"):
			#velocity.y = JUMP_VELOCITY
		
		
	#Get the input direction and handle the movement/deceleration. 
	if not Gliding:
		if direction:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * GROUND_SPEED, ACCELERATION_SPEED)
			else:
				velocity.x = move_toward(velocity.x, direction * AIR_SPEED, ACCELERATION_AIR)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATON_SPEED)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * AIR_SPEED, ACCELERATION_FLYING)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATON_SPEED_AIR)
		
		#if velocity.x > 5: 
			#velocity.x += PASSIVE_ACCEL_AIR 
		#elif velocity.x < -5: 
			#velocity.x -= PASSIVE_ACCEL_AIR
	
	move_and_slide()

func coyote_timer_done(): #For Coyote time 
	coyote_time = false
