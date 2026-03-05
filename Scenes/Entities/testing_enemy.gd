extends CharacterBody2D

var Direction = 1
var Alert = false
var Player_Position
var Enemy_Position = self.position.x
#var Distance = Enemy_Position - Player_Position
var Speed = 25

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft


func _ready():
	#Player_Position = get_parent().get_node("Player").position.x
	pass


#EnemyScountingMovement
func _process(delta: float) -> void:
	Player_Position = get_parent().get_node("Player").position.x
	Enemy_Position = self.position.x
	
	if ray_right.is_colliding() and Alert == false : #If wall on right turn around
		Direction = -1
	if ray_left.is_colliding() and Alert == false: #If wall on left turn around
		Direction = 1
		
		
	if Alert == false: #Patroling when player is out of view
		position.x += Direction * Speed * delta

	if Alert: #Chasing player when in view
		
		if Enemy_Position - Player_Position < 0: #Positive
			velocity.x = move_toward(velocity.x, Speed, 5)
			print("Targeted")
		if Enemy_Position - Player_Position > 0: #Negative
			velocity.x = move_toward(velocity.x, -Speed, 5)

			print("Otherway")
			
			
		#position.x = move_toward(position.x, Enemy_Position.x, Speed)
	
	move_and_slide()
	
func _on_alerting_area_body_entered(_body: Node2D) -> void: #Player is in view
	Alert = true
func _on_alerting_area_body_exited(_body: Node2D) -> void: #Player is not in view
	Alert = false
