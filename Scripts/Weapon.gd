extends Node2D

@export var pork = 3

var attack_delay = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -12
	$attack_box/midle/Sprite2D.hide()
	$attack_box/right/Sprite2D2.hide()
	$attack_box/left/Sprite2D3.hide()

func _process(_delta: float) -> void:
	if attack_delay == true:
		await get_tree().create_timer(.6666666).timeout
		attack_delay = false

func _physics_process(_delta: float) -> void:

	#attack of upper right
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right") and Input.is_action_just_pressed("Up") and attack_delay == false:
		attack_delay = true
		$attack_box.rotate(PI/4)
		position.x = 47.80042
		position.y = -59.80042
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/right/Sprite2D2.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/right/Sprite2D2.hide()
		$attack_box/right.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/midle/Sprite2D.hide()
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.166).timeout
		$attack_box/left/Sprite2D3.hide()
		$attack_box/left.set_deferred("disabled", true)
		position.x = 0
		position.y = -12
		$attack_box.rotate(-PI/4)
		
	#attack of down right
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right") and Input.is_action_just_pressed("Down") and attack_delay == false:
		attack_delay = true
		$attack_box.rotate(PI/4)
		position.x = 47.80042
		position.y = 35.80042
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.hide()
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle/Sprite2D.hide()
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()
		await get_tree().create_timer(.166).timeout
		$attack_box/right/Sprite2D2.hide()
		$attack_box/right.set_deferred("disabled", true)
		position.x = 0
		position.y = -12
		$attack_box.rotate(-PI/4)
		
	#attack of left up
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left") and Input.is_action_just_pressed("Up") and attack_delay == false:
		attack_delay = true
		$attack_box.rotate(PI/4)
		position.x = -47.80042
		position.y = -59.80042
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.hide()
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle/Sprite2D.hide()
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()
		await get_tree().create_timer(.166).timeout
		$attack_box/right/Sprite2D2.hide()
		$attack_box/right.set_deferred("disabled", true)
		position.x = 0
		position.y = -12
		$attack_box.rotate(-PI/4)
		
	#attack of left down
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left") and Input.is_action_just_pressed("Down") and attack_delay == false:
		attack_delay = true
		$attack_box.rotate(PI/4)
		position.x = -47.80042
		position.y = 35.80042
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.hide()
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle/Sprite2D.hide()
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()
		await get_tree().create_timer(.166).timeout
		$attack_box/right/Sprite2D2.hide()
		$attack_box/right.set_deferred("disabled", true)
		position.x = 0
		position.y = -12
		$attack_box.rotate(-PI/4)
		
	#attack to the right
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right") and attack_delay == false:
		attack_delay = true
		position.x = 67.5
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.hide()
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()

		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle/Sprite2D.hide()
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()

		await get_tree().create_timer(.166).timeout
		$attack_box/right/Sprite2D2.hide()
		$attack_box/right.set_deferred("disabled", true)

		position.x = 0
		
	#attack to the Up
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Up") and attack_delay == false:
		attack_delay = true
		$attack_box.rotate(PI/2)
		position.y = -79.5
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.hide()
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle/Sprite2D.hide()
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()
		await get_tree().create_timer(.166).timeout
		$attack_box/right/Sprite2D2.hide()
		$attack_box/right.set_deferred("disabled", true)
		position.y = -12
		$attack_box.rotate(-PI/2)
		
	#attack to the left
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left") and attack_delay == false:
		attack_delay = true
		$attack_box.rotate(PI)
		position.x = -67.5
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/right/Sprite2D2.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/right/Sprite2D2.hide()
		$attack_box/right.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/midle/Sprite2D.hide()
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.166).timeout
		$attack_box/left/Sprite2D3.hide()
		$attack_box/left.set_deferred("disabled", true)
		position.x = 0
		$attack_box.rotate(-PI)

	#attack to the Down
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Down") and attack_delay == false:
		attack_delay = true
		$attack_box.rotate(-PI/2)
		position.y = 79.5
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left/Sprite2D3.hide()
		$attack_box/left.set_deferred("disabled", true)
		$attack_box/midle/Sprite2D.show()
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle/Sprite2D.hide()
		$attack_box/midle.set_deferred("disabled", true)
		$attack_box/right/Sprite2D2.show()
		await get_tree().create_timer(.166).timeout
		$attack_box/right/Sprite2D2.hide()
		$attack_box/right.set_deferred("disabled", true)
		position.y = -12
		$attack_box.rotate(PI/2)
	#these are the diagonals
	


func _on_attack_box_body_entered(body: Node2D) -> void:
	body.get_node("Health_Manager").Damage(pork)
