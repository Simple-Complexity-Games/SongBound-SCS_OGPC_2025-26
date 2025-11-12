extends Camera2D

@onready var player = %Player

const FOLLOW_SPEED = 0.3


func _physics_process(delta):
	position = position.move_toward(player.position, position.distance_to(player.position) * FOLLOW_SPEED)
