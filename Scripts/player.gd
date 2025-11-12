extends CharacterBody2D

#Constants for Movement/Jump
const ACCELERATION_GROUND = 35 # Grounded acceleration
const ACCELERATION_AIR = 30 # Ungrounded acceleration
const DECELERATON_SPEED = 20 
const DECELERATON_SPEED_AIR = 0.005
const ACCELERATION_FLYING = 20
const PASSIVE_ACCEL_AIR = 2
const GROUND_SPEED = 200.0
const AIR_SPEED = 150
const JUMP_VELOCITY = -400.0
const MAX_JUMPS = 2
const MAX_GLIDE_SPEED = 380
const MIN_GLIDE_SPEED = 40
const MAX_FALL_SPEED = 415
const GLIDE_ACCELERATION = 12

# Variables for Movement/Jump
var direction = 0
var total_jumps = 0 # Total amount of jumps you've done
var jumping = false # Tells us if we're jumping
var gliding = false
var gliding_speed = 100


# Variables for Coyote Time
var on_ground = false
var coyote_time = false
var coyote_jump_timer = SceneTreeTimer
var coyote_seconds = 0.15

var abilities = {"flight":0, "glide":1}


func _process(delta: float) -> void:
	Handle_Inputs()

func _physics_process(delta: float) -> void:
	#Apply gravity
	if not on_ground and not gliding and velocity.y < MAX_FALL_SPEED: 
		velocity += get_gravity() * delta
	
	
	Update_Status_Vars()
	
	Handle_Jump()
	
	Handle_Glide()
	
	move_and_slide()


func Update_Status_Vars():
	if is_on_floor():
		jumping = false
		gliding = false
		total_jumps = 0 # Reset extra jumps
		on_ground = true
	else:
		if on_ground: 
			on_ground = false
			coyote_time = true
			
			coyote_jump_timer = get_tree().create_timer(coyote_seconds, false, true)
			coyote_jump_timer.timeout.connect(coyote_timer_done.bind())

func Handle_Inputs():
	direction = Input.get_axis("Move_Left", "Move_Right") # For left and right movement. 
	
	if Input.is_action_pressed("Gliding") and not is_on_floor() and not gliding: # Turns on Gliding
		gliding = true
	elif Input.is_action_just_released("Gliding") and gliding:
		gliding = false

func Handle_Jump():
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote_time) and not gliding and total_jumps < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jumping = true
		total_jumps += 1
	elif Input.is_action_just_pressed("Jump") and (total_jumps < MAX_JUMPS or abilities.get("flight")):
		velocity.y = JUMP_VELOCITY
		total_jumps += 1
	elif Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y = velocity.y / 3
		jumping = false

func Handle_Glide(): 
	if gliding:
		velocity.y = move_toward(velocity.y, (((MIN_GLIDE_SPEED - MAX_GLIDE_SPEED)/AIR_SPEED) * (abs(velocity.x) - AIR_SPEED) + MIN_GLIDE_SPEED), GLIDE_ACCELERATION)
		
		#if velocity.x > 5: 
			#velocity.x += PASSIVE_ACCEL_AIR 
		#elif velocity.x < -5: 
			#velocity.x -= PASSIVE_ACCEL_AIR
	
	# Get the input direction and handle the movement/deceleration. 
	if not gliding:
		if direction:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * GROUND_SPEED, ACCELERATION_GROUND)
			else:
				velocity.x = move_toward(velocity.x, direction * AIR_SPEED, ACCELERATION_AIR)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATON_SPEED)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * AIR_SPEED, ACCELERATION_FLYING)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATON_SPEED_AIR)


func coyote_timer_done(): # For Coyote time 
	coyote_time = false
