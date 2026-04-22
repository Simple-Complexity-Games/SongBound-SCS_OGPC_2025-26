extends Node2D

@export var dmg = 25
var last_used = 0
var attack_delay = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -12

func _delay():
	await get_tree().create_timer(.6666666).timeout
	attack_delay = false

func _physics_process(_delta: float) -> void:
	#attack of upper right
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right") and Input.is_action_just_pressed("Up") and attack_delay == false:
		attack_delay = true
		rotate(PI/4)
		$attack_box.position.x = 47.80042
		$attack_box.position.y = -59.80042
		$attack_box/right.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/right.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/left.set_deferred("disabled", true)
		$attack_box.position.x = 0
		$attack_box.position.y = -12
		rotate(-PI/4)
		print("work")
	if attack_delay == true:
		_delay()
		
	#attack of down right
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Right") and Input.is_action_just_pressed("Down") and attack_delay == false:
		attack_delay = true
		rotate(PI/4)
		$attack_box.position.x = 47.80042
		$attack_box.position.y = 35.80042
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		$attack_box.position.x = 0
		$attack_box.position.y = -12
		rotate(-PI/4)
		print("work")
	if attack_delay == true:
		_delay()
		
	#attack of left up
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left") and Input.is_action_just_pressed("Up") and attack_delay == false:
		attack_delay = true
		rotate(PI/4)
		$attack_box.position.x = -47.80042
		$attack_box.position.y = -59.80042
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		$attack_box.position.x = 0
		$attack_box.position.y = -12
		rotate(-PI/4)
		print("work")
	if attack_delay == true:
		_delay()
		
	#attack of left down
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Left") and Input.is_action_just_pressed("Down") and attack_delay == false:
		attack_delay = true
		rotate(PI/4)
		$attack_box.position.x = -47.80042
		$attack_box.position.y = 35.80042
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		$attack_box.position.x = 0
		$attack_box.position.y = -12
		rotate(-PI/4)
		print("work")
	if attack_delay == true:
		_delay()
	
	#attack to the Down
	if Input.is_action_pressed("Attack") and Input.is_action_pressed("Down") and attack_delay == false:
		attack_delay = true
		rotate(-PI/2)
		$attack_box.position.y = 79.5
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		$attack_box.position.y = -12
		rotate(PI/2)
		print("work")
	if attack_delay == true:
		_delay()
	
	if Input.is_action_pressed("Right"):
		last_used = 1
	
	if Input.is_action_pressed("Left"):
		last_used = 2
		_delay()
	
	if Input.is_action_pressed("Up"):
		last_used = -1
	
	if Input.is_action_pressed("Attack") and last_used == 1 and attack_delay == false:
		attack_delay = true
		$attack_box.position.x = 67.5
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		position.x = 0
		print("work")
	if attack_delay == true:
		_delay()
	
	if Input.is_action_pressed("Attack") and last_used == 2 and attack_delay == false:
		attack_delay = true
		rotate(PI)
		$attack_box.position.x = -67.5
		$attack_box/right.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/right.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/left.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/left.set_deferred("disabled", true)
		position.x = 0
		$attack_box.rotate(-PI)
		print("work")
	if attack_delay == true:
		_delay()
	
	if Input.is_action_pressed("Attack") and last_used == -1 and attack_delay == false:
		attack_delay = true
		rotate(PI/2)
		$attack_box.position.y = -79.5
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		position.y = -12
		$attack_box.rotate(-PI/2)
		print("work")
	if attack_delay == true:
		_delay()

func _on_attack_box_body_exited(body: Node2D) -> void:
	if body.get_node("Health_Manager") != null:
		body.get_node("Health_Manager").Damage(dmg)
		print(dmg)
