extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -12

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right"):
		position.x = 67.5
		$attack_box/CollisionShape2D.set_deferred("disabled", false)
		await get_tree().create_timer(1).timeout
		$attack_box/CollisionShape2D.set_deferred("disabled", true)
		position.x = 0

# 80 pixels form player for the middle hit boxes right side to the players right side. each box is 25 wide, 8 tall.
#think of its middle of 12 when possitioning as in minus it by 12 dumbass
