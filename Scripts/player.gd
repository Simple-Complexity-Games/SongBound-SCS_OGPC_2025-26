extends CharacterBody2D

@onready var Perch_Collision_Area = get_node("Perch_Collision_Area")

#region ------Movement Constant Definitions------
const ACCELERATION_GROUND = 20 # Grounded acceleration
const ACCELERATION_AIR = 30 # Ungrounded acceleration
const DECELERATON_SPEED = 12 
const DECELERATON_SPEED_AIR = 0.005
const ACCELERATION_FLYING = 20
const PASSIVE_ACCEL_AIR = 2
const GROUND_SPEED = 240.0
const AIR_SPEED = 160.0
const JUMP_VELOCITY = -300
const JUMP_GRAVITY_MULT = 0.55
const MAX_JUMPS = 2
const MAX_GLIDE_SPEED = 380
const MIN_GLIDE_SPEED = 40
const MAX_FALL_SPEED = 515
const SOFT_GRAVITY_SECONDS = 0.08
const GLIDE_ACCELERATION = 12
const PERCH_LANDING_SPEED = 0.5
const PERCH_DECELERATION_SPEED = 10
const PERCH_TWEEN_TIME = 0.4
const HOVER_SPEED = 150
const HOVERING_DECELERATION = 5
#endregion

# Variables for Movement/Jump
var soft_gravity_timer = null

var direction = 0
var total_jumps = 0 # Total amount of jumps you've done
var jumping = false # Tells us if we're jumping
var gliding = false
var gliding_speed = 100
var can_perch = false
var perch_coordinates = Vector2(0, 0)
var perching = false
var perch_buffer = false
var hovering = false
var hover_queued = false


# Variables for Coyote Time
var on_ground = false
var coyote_time = false
var coyote_jump_timer = SceneTreeTimer
var coyote_seconds = 0.15

var abilities = {"flight":0, "glide":1}

# Variable for handling fullscreen requests (f11 on windows)
var previous_window_mode = DisplayServer.WINDOW_MODE_MAXIMIZED

var hover_velocity_tween
var perch_velocity_tween
var perch_position_tween

var print_debugging = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	Handle_Inputs()
	Handle_Fullscreening()
	
	#Developer Tools
	if Input.is_action_just_pressed("Teleport_Up"):
		position.y -= 200
		
	if Input.is_action_just_pressed("Teleport_Down"):
		position.y += 200
		
	if Input.is_action_just_pressed("Teleport_Left"):
		position.x -= 1500
		
	if Input.is_action_just_pressed("Teleport_Right"):
		position.x += 1500

func _physics_process(delta: float) -> void:
	if soft_gravity_timer != null:
		if velocity.y < 0 and abs(velocity.y) > 5:
			soft_gravity_timer = null
	
	#Apply gravity
	if (not gliding or hovering) and ((not perching) or jumping) and velocity.y < MAX_FALL_SPEED - (int(hovering) * (MAX_FALL_SPEED - HOVER_SPEED)):
		if print_debugging: print("gravity")
		if soft_gravity_timer != null:
			if soft_gravity_timer.time_left > 0:
				velocity += get_gravity() * delta * ((SOFT_GRAVITY_SECONDS - soft_gravity_timer.time_left) / SOFT_GRAVITY_SECONDS)
				if print_debugging: print("soft grav")
			else:
				soft_gravity_timer = null
		else: 
			if not jumping:
				if print_debugging: print("normal grav")
				velocity += get_gravity() * delta
			else:
				velocity += get_gravity() * delta * JUMP_GRAVITY_MULT
				if print_debugging: print("jump grav")
	
	Update_Status_Vars()
	
	Handle_Jump()
	
	Handle_Glide()
	
	Handle_Perch()
	
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
			coyote_jump_timer.timeout.connect(Coyote_Timer_Done.bind())
			if print_debugging: print("soft gravity start")
			soft_gravity_timer = get_tree().create_timer(SOFT_GRAVITY_SECONDS, false, true)

func Handle_Inputs():
	if not perching:
		if print_debugging: print("moving again")
		direction = Input.get_axis("Left", "Right") # For left and right movement. 
	
	if Input.is_action_pressed("Glide") and not is_on_floor() and not gliding: # Turns on Gliding
		jumping = false
		gliding = true
	elif Input.is_action_just_released("Glide") and gliding:
		gliding = false

func Handle_Jump():
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or coyote_time) and not gliding and total_jumps < MAX_JUMPS:
		if print_debugging: print("jump1")
		if perching:
			if print_debugging: print("perch tween kill")
			perching = false
			perch_buffer = false
			perch_velocity_tween.kill()
			perch_position_tween.kill()
		if hover_velocity_tween != null:
			hovering = false
			hover_velocity_tween.kill()
			if print_debugging: print("kill")
		jumping = true
		
		if soft_gravity_timer != null:
			soft_gravity_timer = null
		velocity.y = JUMP_VELOCITY
		total_jumps += 1
	elif Input.is_action_just_pressed("Jump") and total_jumps < MAX_JUMPS and not (is_on_floor() or coyote_time):
		if print_debugging: print("jump2")
		if perching:
			if print_debugging: print("perch tween kill")
			perching = false
			perch_buffer = false
			perch_velocity_tween.kill()
			perch_position_tween.kill()
		if hover_velocity_tween != null:
			hovering = false
			hover_velocity_tween.kill()
			if print_debugging: print("kill")
		jumping = true
		
		if soft_gravity_timer != null:
			soft_gravity_timer = null
		velocity.y = JUMP_VELOCITY
		total_jumps += 1
	elif Input.is_action_just_pressed("Jump") and (total_jumps < MAX_JUMPS or abilities.get("flight")):
		if print_debugging: print("jump3")
		if perching:
			if print_debugging: print("perch tween kill")
			perching = false
			perch_buffer = false
			perch_velocity_tween.kill()
			perch_position_tween.kill()
		if hover_velocity_tween != null:
			hovering = false
			hover_velocity_tween.kill()
			if print_debugging: print("kill")
		jumping = true
		
		if soft_gravity_timer != null:
			soft_gravity_timer = null
		velocity.y = JUMP_VELOCITY
		total_jumps += 1
	elif Input.is_action_just_released("Jump") or (velocity.y > 0 and not is_on_floor() and not perching):
		jumping = false

func Handle_Glide(): 
	if gliding and not hovering and not perching:
		if print_debugging: print("glide velocity change")
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
				if not perching:
					velocity.x = move_toward(velocity.x, direction * AIR_SPEED, ACCELERATION_AIR)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATON_SPEED)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * AIR_SPEED, ACCELERATION_FLYING)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATON_SPEED_AIR)

func Handle_Perch():
	if Input.is_action_pressed("Up"):
		if hovering and not perching:
			if velocity.x > 10:
				velocity.x = move_toward(velocity.x, 10, HOVERING_DECELERATION * (velocity.x / 10))
			if velocity.x < -10:
				velocity.x = move_toward(velocity.x, -10, HOVERING_DECELERATION * (-velocity.x / 10))
		
		if velocity.y > HOVER_SPEED and hover_queued and not perching and not jumping:
			if print_debugging: print("start hover")
			hover_queued = false
			hovering = true
			hover_velocity_tween = create_tween().set_ease(Tween.EASE_OUT)
			hover_velocity_tween.tween_property(self, "velocity:y", HOVER_SPEED, 0.8)
	if Input.is_action_just_pressed("Up"):
		jumping = false
		hover_queued = true
		get_tree().create_timer(0.1).timeout.connect(Perch_Buffer_Over)
		perch_buffer = true
		
		if perching:
			if perch_velocity_tween != null and perch_position_tween != null:
				perch_velocity_tween.kill()
				perch_position_tween.kill()
				perching = false
	
	if perching and (Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Right")):
		if not jumping:
			soft_gravity_timer = get_tree().create_timer(1, false, true)
		if perch_velocity_tween != null and perch_position_tween != null:
			if print_debugging: print("direction perch kill")
			perch_velocity_tween.kill()
			perch_position_tween.kill()
			perching = false
	
	if can_perch and perch_buffer and not perching:
		direction = 0
		perching = true
		perch_coordinates = self.position
		if print_debug: print("tweens started")
		perch_velocity_tween = create_tween().set_ease(Tween.EASE_OUT)
		perch_velocity_tween.parallel().tween_property(self, "velocity:y", 0, PERCH_TWEEN_TIME)
		perch_position_tween = create_tween().set_ease(Tween.EASE_OUT)
		perch_position_tween.parallel().tween_property(self, "position", perch_coordinates, PERCH_TWEEN_TIME)
		if not jumping:
			total_jumps = 0
	
	if Input.is_action_just_released("Up"):
		if print_debug: print("hover release")
		hover_queued = false
		hovering = false
		if hover_velocity_tween != null:
			hover_velocity_tween.kill()

func Handle_Fullscreening():
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			previous_window_mode = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(previous_window_mode)

func Coyote_Timer_Done(): # For Coyote time 
	coyote_time = false

func Perch_Buffer_Over():
	perch_buffer = false

func _on_perch_collision_area_body_entered(_body: Node2D) -> void:
	can_perch = true
	if perching == false:
		perch_coordinates = self.position
func _on_perch_collision_area_body_exited(_body: Node2D) -> void:
	if not Perch_Collision_Area.has_overlapping_bodies():
		can_perch = false
		await get_tree().create_timer(0.5).timeout
		if not Perch_Collision_Area.has_overlapping_bodies():
			if perching and not perch_position_tween.is_running and not perch_velocity_tween.is_running:
				perching = false
				if print_debug: print("perch reset")
