extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -12
	$attack_box/midle/Sprite2D.hide()
	$attack_box/right/Sprite2D2.hide()
	$attack_box/left/Sprite2D3.hide()

func _physics_process(_delta: float) -> void:
	#attack to the right
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right"):
		position.x = 67.5
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		$attack_box/left/Sprite2D3.hide()
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()
		$attack_box/midle/Sprite2D.hide()
		await get_tree().create_timer(.166).timeout
		$attack_box/right.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.hide()
		position.x = 0
	#attack to the Up
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Up"):
		$attack_box.rotate(PI/2)
		position.y = -79.5
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		$attack_box/left/Sprite2D3.hide()
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()
		$attack_box/midle/Sprite2D.hide()
		await get_tree().create_timer(.166).timeout
		$attack_box/right.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.hide()
		position.y = -12
		$attack_box.rotate(-PI/2)
	#attack to the left
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left"):
		$attack_box.rotate(PI)
		position.x = -67.5
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/right/Sprite2D2.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/right.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		$attack_box/right/Sprite2D2.hide()
		await get_tree().create_timer(.1666).timeout
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/left/Sprite2D3.show()
		$attack_box/midle/Sprite2D.hide()
		await get_tree().create_timer(.166).timeout
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/left/Sprite2D3.hide()
		position.x = 0
		$attack_box.rotate(-PI)
	#attack to the Down
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Down"):
		$attack_box.rotate(-PI/2)
		position.y = 79.5
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		$attack_box/left/Sprite2D3.hide()
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()
		$attack_box/midle/Sprite2D.hide()
		await get_tree().create_timer(.166).timeout
		$attack_box/right.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.hide()
		position.y = -12
		$attack_box.rotate(PI/2)

# 80 pixels form player for the middle hit boxes right side to the players right side. each box is 25 wide, 8 tall.
#think of its middle of 12 when possitioning as in minus it by 12 dumbass
