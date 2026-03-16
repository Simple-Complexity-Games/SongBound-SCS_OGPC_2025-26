extends Node2D

var attack_delay = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -12
	$attack_box/midle/Sprite2D.hide()
	$attack_box/right/Sprite2D2.hide()
	$attack_box/left/Sprite2D3.hide()

func _physics_process(_delta: float) -> void:
	#attack to the right
	if attack_delay == true:
		await get_tree().create_timer(1.5).timeout
		attack_delay = false
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right") and attack_delay == false:
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
		attack_delay = true
	#attack to the Up
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Up") and attack_delay == false:
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
		attack_delay = true
	#attack to the left
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left") and attack_delay == false:
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
		attack_delay = true
	#attack to the Down
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Down") and attack_delay == false:
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
		attack_delay = true
	#these are the diagonals
	
	#attack of upper right
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right") and Input.is_action_just_pressed("Up") and attack_delay == false:
		$attack_box.rotate(PI/4)
		position.x = 47.80042
		position.y = -59.80042
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
		position.y = -12
		$attack_box.rotate(-PI/4)
		attack_delay = true
	#attack of down right
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right") and Input.is_action_just_pressed("Down") and attack_delay == false:
		$attack_box.rotate(PI/4)
		position.x = 47.80042
		position.y = 35.80042
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
		position.y = -12
		$attack_box.rotate(-PI/4)
		attack_delay = true
	#attack of left up
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left") and Input.is_action_just_pressed("Up") and attack_delay == false:
		$attack_box.rotate(PI/4)
		position.x = -47.80042
		position.y = -59.80042
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
		position.y = -12
		$attack_box.rotate(-PI/4)
		attack_delay = true
	#attack of left down
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left") and Input.is_action_just_pressed("Down") and attack_delay == false:
		$attack_box.rotate(PI/4)
		position.x = -47.80042
		position.y = 35.80042
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
		position.y = -12
		$attack_box.rotate(-PI/4)
		attack_delay = true
		
