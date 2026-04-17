extends CharacterBody2D


var Direction = 1 #Changes the direction of enemy while moving
var Speed = 120
var Jump_Power = -400
var Player_Position
var Combined_Position #Subtracting the enmey position to the player position
var Alert = false #Will chase the player when true
var Aggro_Timer = 0  #Timer for how long the enemy will chase the player till it gives up and stops.
var Chase = false 
var Dash = true
var Dash_Timer = 0 #Cooldown for Dash Ability
var RetreatTime = true
var Retreat = false
var RetreatBackward #How much they move backward from Retreat ability
var Health = 180


@onready var ray_right: RayCast2D = $RayRight #Both Rays used for idle state
@onready var ray_left: RayCast2D = $RayLeft
@onready var sprite_2d: Sprite2D = $Sprite2D #Used to flip fox's image


var dmg = 3

#EnemyScountingMovement
func _physics_process(delta: float) -> void:
	Health = $Health_Manager.current_health #Health of Fox
	#print(Health)
	
	if Dash:
		dmg = 2
	else:
		dmg = 3
	var gravity = 1500 
	velocity.y += gravity * delta 
	
	
	Player_Position = get_parent().get_node("Player").position.x
	Combined_Position = self.position.x - Player_Position
	
	if Combined_Position < 0: #Which direction Retreat goes
		RetreatBackward = -400
	if Combined_Position > 0:
		RetreatBackward = 400
	
	if ray_right.is_colliding() and Alert == false : #If wall on right turn around
		Direction = -1
		sprite_2d.flip_h = true
	if ray_left.is_colliding() and Alert == false: #If wall on left turn around
		Direction = 1
		sprite_2d.flip_h = false
	
	
	if !Alert: #Patroling when player is out of view
		position.x += Direction * Speed * delta
	
	
	if Combined_Position < 64 and Combined_Position > -64:
		Dash = false
		$DashTimer.start()
	
	
	
	if Health < 144 and Health > 90 and Alert and is_on_floor()or Health < 90 and Alert and is_on_floor():
		Retreat = true
		#print(Retreat)
	
	
	if Retreat and RetreatTime: #Disable the Retreat once you get back onto the floor.
		print(Retreat) 
		velocity = Vector2(RetreatBackward,Jump_Power)
		RetreatTime = false
	
	
	if Alert and not Dash: #Chasing player whenever Alert or Chase equals true
		if Combined_Position < 0:
			if Health == 180 or Health < 90:
				velocity.x = move_toward(velocity.x, Speed, 5) #Normal Positive movement
				sprite_2d.flip_h = true
			if Health < 180 and Health > 90:
				velocity.x = move_toward(velocity.x, Speed*2.5, 10) #Faster Positive movement
				sprite_2d.flip_h = true
		if Combined_Position > 0:
			if Health == 180 or Health < 90:
				velocity.x = move_toward(velocity.x, -Speed, 5) #Normal Negative movement
				sprite_2d.flip_h = false
			if Health < 180 and Health > 90:
				velocity.x = move_toward(velocity.x, -Speed*2.5, 10) #Faster Negative movement
				sprite_2d.flip_h = false
	
	
	if Dash and Alert: #Enemy's dash ability
		if Combined_Position > 64: #Dash, Positive
			velocity.x = move_toward(velocity.x, -Speed*4,150)
			sprite_2d.flip_h = true
		if Combined_Position < -64: #Dash, Negative
			velocity.x = move_toward(velocity.x, Speed*4, 150)
			sprite_2d.flip_h = false
	
	if abs(self.velocity.x) > Speed: #Decleration for Dash
		if self.velocity.x > 0:
			velocity.x = move_toward(velocity.x, Speed, 5)
		elif self.velocity.x < 0:
			velocity.x = move_toward(velocity.x, -Speed, 5)
	
	move_and_slide()


func _on_alerting_area_body_entered(_body: Node2D) -> void: #Player is in view
	Alert = true
	Chase = false
func _on_alerting_area_body_exited(_body: Node2D) -> void: #Player is not in view
	$AggroTimer.start()
	Chase = true
	Aggro_Timer = 0 #Restarting the Aggro_Timer if not in range


func _on_timer_timeout() -> void: #three second timer
	Alert = false
	print("Fox", Alert)
	
func _on_dash_timer_timeout() -> void: #Dash Timer
	Dash = true

func _on_damage_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.get_node("Health_Manager").Damage(dmg)
