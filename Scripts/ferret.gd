extends CharacterBody2D

var Direction = 1
var Player_Position
var Enemy_Position = self.position.x #Getting enemy position
var Combined_Position
var Speed = 50
var Alert = false #Becomes true once the player comes into the sphere. Will chase the player when true
var Aggro_Timer = 0  #Timer for how long the enemy will chase the player till it gives up and stops.
var Chase = false 
var Dash = true
var Dash_Timer = 0 #Cooldown for Dash Ability

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft
@onready var sprite_2d: Sprite2D = $Sprite2D


@export var dmg = 3

#EnemyScountingMovement
func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta 

	Player_Position = get_parent().get_node("Player").position.x
	Enemy_Position = self.position.x
	Combined_Position = Enemy_Position - Player_Position

	if ray_right.is_colliding() and Alert == false : #If wall on right turn around
		Direction = -1
	if ray_left.is_colliding() and Alert == false: #If wall on left turn around
		Direction = 1
	
	
	if !Alert: #Patroling when player is out of view
		position.x += Direction * Speed * delta
		
	if Combined_Position <= 64:
		Dash = false
		$DashTimer.start()
		print(Dash)
	
	if Alert and not Dash: #Chasing player whenever Alert or Chase equals true
		if Combined_Position < 0: #Positive
			velocity.x = move_toward(velocity.x, Speed, 5)
			sprite_2d.flip_h = true
		if Combined_Position > 0: #Negative
			velocity.x = move_toward(velocity.x, -Speed, 5)
			sprite_2d.flip_h = false

	if Dash and Alert:
		print(Combined_Position)
		if Combined_Position < 64: #Dash, Positive
			velocity.x = move_toward(velocity.x, Speed*7,150)
			sprite_2d.flip_h = true
		if Combined_Position > 64: #Dash, Negative
			velocity.x = move_toward(velocity.x, -Speed*7, 150)
			sprite_2d.flip_h = false
	
	move_and_slide()


func _on_alerting_area_body_entered(_body: Node2D) -> void: #Player is in view
	Alert = true
	Chase = false
func _on_alerting_area_body_exited(_body: Node2D) -> void: #Player is not in view
	$AggroTimer.start()
	Chase = true
	Aggro_Timer = 0 #Restarting the Aggro_Timer if not in range

func _on_timer_timeout() -> void: #three second timer
	if Aggro_Timer <= 9 and Chase == true: #Plusing it once each time the timer goes off
		Aggro_Timer += 1
		$AggroTimer.start()
		print(Aggro_Timer)
	if Aggro_Timer == 10: #If the Agrro_Timer reaches 10 than we reset the timer and unalert the enemy
		Alert = false

func _on_dash_timer_timeout() -> void:
	Dash_Timer += 1 
	if Dash_Timer <= 5:
		Dash = true
		Dash_Timer = 0
	$DashTimer.start()

func _on_damage_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.get_node("Health_Manager").Damage(dmg)
