extends CharacterBody2D


var Direction = 1 #Changes the direction of enemy while moving
var Speed = 150
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
var Health = 500

@onready var Animated_Sprite: AnimatedSprite2D = $Sprite2D


var dmg = 7

signal slain


#EnemyScountingMovement
func _physics_process(delta: float) -> void:
	Health = $Health_Manager.current_health #Health of Fox
	#print(Health)
	
	if Dash:
		dmg = 5
	elif !Dash:
		dmg = 7

	if Health == 0:
		slain.emit()
	
	var gravity = 1500 
	velocity.y += gravity * delta 
	
	
	Player_Position = get_parent().get_node("Player").position.x
	Combined_Position = self.position.x - Player_Position
	
	if Combined_Position < 0: #Which direction Retreat goes
		RetreatBackward = -400
	if Combined_Position > 0:
		RetreatBackward = 400
	
	
	
	if Combined_Position < 64 and Combined_Position > -64:
		Dash = false
		$DashTimer.start()
	
	
	if Health < 144 and Health > 90 and Alert and is_on_floor() or Health < 90 and Alert and is_on_floor():
		Retreat = true
		#print(RetreatTime)
	
	if Retreat and RetreatTime: #Disable the Retreat once you get back onto the floor. 
		velocity = Vector2(300,Jump_Power)
		RetreatTime = false
	
	
	if Alert and not Dash: #Chasing player whenever Alert or Chase equals true
		if Combined_Position < 0:
			Animated_Sprite.speed_scale = 1
			if Health > 180 or Health < 90:
				velocity.x = move_toward(velocity.x, Speed, 5) #Normal Positive movement
				Animated_Sprite.flip_h = true
				Animated_Sprite.play("Run")
			if Health < 180 and Health > 90:
				velocity.x = move_toward(velocity.x, Speed*2.5, 10) #Faster Positive movement
				Animated_Sprite.flip_h = true
				Animated_Sprite.play("Run")
		if Combined_Position > 0:
			if Health > 180 or Health < 90:
				velocity.x = move_toward(velocity.x, -Speed, 5) #Normal Negative movement
				Animated_Sprite.flip_h = false
				Animated_Sprite.play("Run")
			if Health < 180 and Health > 90:
				velocity.x = move_toward(velocity.x, -Speed*2.5, 10) #Faster Negative movement
				Animated_Sprite.flip_h = false
				Animated_Sprite.play("Run")
	
	
	if Dash and Alert: #Enemy's dash ability
		Animated_Sprite.speed_scale = 0.5
		Animated_Sprite.play("Dash")
		await get_tree().create_timer(1).timeout
		if Combined_Position > 200: #Dash, Positive
			velocity.x = move_toward(velocity.x, -Speed*4,150)
			Animated_Sprite.flip_h = true
		if Combined_Position < -200: #Dash, Negative
			velocity.x = move_toward(velocity.x, Speed*4, 150)
			Animated_Sprite.flip_h = false
	
	if abs(self.velocity.x) > Speed: #Decleration for Dash
		if self.velocity.x > 0:
			velocity.x = move_toward(velocity.x, Speed, 5)
		elif self.velocity.x < 0:
			velocity.x = move_toward(velocity.x, -Speed, 5)
	
	
	if Health <= 0:
		#Animated_Sprite.speed_scale = 1
		#Animated_Sprite.play("Death")
		#await get_tree().create_timer(1).timeout
		self.queue_free()
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


func _on_dash_timer_timeout() -> void: #Dash Timer
	Dash = true

func _on_damage_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.get_node("Health_Manager").Damage(dmg)
