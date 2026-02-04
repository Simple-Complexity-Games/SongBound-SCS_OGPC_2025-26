extends Camera2D

@onready var player = %Player
const FOLLOW_SPEED = 100

func _ready() -> void:
	pass

func _physics_process(_delta):
	self.position = self.position.move_toward(player.position, self.position.distance_to(player.position) * FOLLOW_SPEED)
