extends CharacterBody2D

var Direction = 1
var Player_Position
var Enemy_Position = self.position.x #Getting enemy position
var Speed = 50
#var Idle = false #Agrro timer went off, Alert won't be true till player renters the enemy's sphere
var Alert = false #Becomes true once the player comes into the sphere. Will chase the player when true
var Aggro_Timer = 0  #Timer for how long the enemy will chase the player till it gives up and stops.
var Chase = false

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft

#EnemyScountingMovement
func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta 

	Player_Position = get_parent().get_node("Player").position.x
	Enemy_Position = self.position.x

	if ray_right.is_colliding() and Alert == false : #If wall on right turn around
		Direction = -1
	if ray_left.is_colliding() and Alert == false: #If wall on left turn around
		Direction = 1
	
	
	if !Alert: #Patroling when player is out of view
		position.x += Direction * Speed * delta
	
	if Alert: #Chasing player whenever Alert or Chase equals true
		if Enemy_Position - Player_Position < 0: #Positive
			velocity.x = move_toward(velocity.x, Speed, 5)
		if Enemy_Position - Player_Position > 0: #Negative
			velocity.x = move_toward(velocity.x, -Speed, 5)
	
	move_and_slide()


func _on_alerting_area_body_entered(_body: Node2D) -> void: #Player is in view
	Alert = true
	Chase = false
func _on_alerting_area_body_exited(_body: Node2D) -> void: #Player is not in view
	$AggroTimer.start()
	Chase = true
	Aggro_Timer = 0 #Restarting the Aggro_Timer if not in range
	print(Aggro_Timer)

func _on_timer_timeout() -> void: #three second timer
	if Aggro_Timer <= 9 and Chase == true: #Plusing it once each time the timer goes off
		Aggro_Timer += 1
		$AggroTimer.start()
		print(Aggro_Timer)
	if Aggro_Timer == 10: #If the Agrro_Timer reaches 10 than we reset the timer and unalert the enemy
		Alert = false
