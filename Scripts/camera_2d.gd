extends Camera2D

@onready var player = %Player
const FOLLOW_SPEED = 100

@export var left = -10000000
@export var right = 10000000

func _ready() -> void:
	limit_left = left
	limit_right = right
	
func _physics_process(_delta):
	self.position = self.position.move_toward(player.position, self.position.distance_to(player.position) * FOLLOW_SPEED)
	
