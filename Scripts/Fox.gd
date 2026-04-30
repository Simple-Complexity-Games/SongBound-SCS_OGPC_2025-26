extends CharacterBody2D


var Direction = 1 #Changes the direction of enemy while moving
var Speed = 120
var Jump_Power = -400
var Player_Position
var Combined_Position #Subtracting the enmey position to the player position
var Alert = false #Will chase the player when true
var Chase = false 
var Dash = true
var Dash_Timer = 0 #Cooldown for Dash Ability
var RetreatTime = true
var Retreat = false
var RetreatBackward #How much they move backward from Retreat ability
var Health = 180

var death_animation_node = preload("res://Scenes/Entities/Spawnable_Objects/fox_death_animation.tscn")

@onready var ray_right: RayCast2D = $RayRight #Both Rays used for idle state
@onready var ray_left: RayCast2D = $RayLeft
@onready var Animated_Sprite: AnimatedSprite2D = $Sprite2D


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
		Animated_Sprite.flip_h = false
	if ray_left.is_colliding() and Alert == false: #If wall on left turn around
		Direction = 1
		Animated_Sprite.flip_h = true
	
	
	if !Alert: #Patroling when player is out of view
		position.x += Direction * Speed * delta
	
	
	if Combined_Position < 64 and Combined_Position > -64:
		Dash = false
		$DashTimer.start()
	
	
	
	if Health < 144 and Health > 90 and Alert and is_on_floor()or Health < 90 and Alert and is_on_floor():
		Retreat = true
	
	
	if Retreat and RetreatTime: #Disable the Retreat once you get back onto the floor. 
		velocity = Vector2(RetreatBackward,Jump_Power)
		RetreatTime = false
	
	
	if Alert and not Dash: #Chasing player whenever Alert or Chase equals true
		Animated_Sprite.speed_scale = 1
		if Combined_Position < -100:
			if Health == 180 or Health < 90:
				velocity.x = move_toward(velocity.x, Speed, 5) #Normal Positive movement
				Animated_Sprite.flip_h = true
				Animated_Sprite.play("Run")
			if Health < 180 and Health > 90:
				velocity.x = move_toward(velocity.x, Speed*2.5, 10) #Faster Positive movement
				Animated_Sprite.flip_h = true
				Animated_Sprite.play("Run")
		if Combined_Position > 100:
			if Health == 180 or Health < 90:
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
		if Combined_Position > 100: #Dash, Positive
			velocity.x = move_toward(velocity.x, -Speed*3,150)
			Animated_Sprite.flip_h = false
			Dash = false
		if Combined_Position < -100: #Dash, Negative
			velocity.x = move_toward(velocity.x, Speed*3, 150)
			Animated_Sprite.flip_h = true
			Dash = false
	
	if abs(self.velocity.x) > Speed: #Decleration for Dash
		if self.velocity.x > 0:
			velocity.x = move_toward(velocity.x, Speed, 10)
		elif self.velocity.x < 0:
			velocity.x = move_toward(velocity.x, -Speed, 10)
	
	
	if Health <= 0:
		#Animated_Sprite.speed_scale = 1
		#print(Animated_Sprite.speed_scale)
		#Animated_Sprite.play("Death")
		var instance = death_animation_node.instantiate()
		get_parent().add_child(instance)
		instance.position = self.position
		self.queue_free()
	move_and_slide()


func _on_alerting_area_body_entered(_body: Node2D) -> void: #Player is in view
	Alert = true
	Chase = false
func _on_alerting_area_body_exited(_body: Node2D) -> void: #Player is not in view
	$AggroTimer.start()
	Chase = true


func _on_timer_timeout() -> void: #three second timer
	Alert = false
	
func _on_dash_timer_timeout() -> void: #Dash Timer
	Dash = true


func _on_damage_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	body.get_node("Health_Manager").Damage(dmg)
