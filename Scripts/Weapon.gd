extends Node2D

@export var dmg = 25
var last_used = 0
var attack_delay = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -12

func _delay():
	await get_tree().create_timer(.5555555).timeout
	attack_delay = false

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("Right"):
		last_used = 1
	
	if Input.is_action_pressed("Left"):
		last_used = 2
	
	if Input.is_action_pressed("Up"):
		last_used = -1
	
	if Input.is_action_pressed("Down"):
		last_used = -2
	
	#attack right
	if Input.is_action_pressed("Attack") and last_used == 1 and attack_delay == false:
		attack_delay = true
		$Shaft.show()
		await get_tree().create_timer(.03333).timeout
		$Shaft.position.x = 26
		$Shaft.rotation = deg_to_rad(-4.8)
		var tween = get_tree().create_tween()
		tween.tween_property($Shaft,"rotation",deg_to_rad(4.8),.12495).as_relative()
		tween.tween_property($Shaft,"position.x",7,.12495)
		$attack_box.position.x = 67.5
		$attack_box/left.set_deferred("disabled", false)
		$Shaft2.show()
		#$weaponsprite.position.x = 26
		await get_tree().create_timer(.12495).timeout
		$attack_box/midle.set_deferred("disabled", false)
		#$weaponsprite.position.x = 33
		$Shaft2.hide()
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.12495).timeout
		$attack_box/right.set_deferred("disabled", false)
		$Shaft3.show()
		#$weaponsprite.position.x = 26
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.12495).timeout
		$attack_box/right.set_deferred("disabled", true)
		$Shaft3.hide()
		$Shaft.hide()
		#$weaponsprite.position.x = 0
		$attack_box.position.x = 0
		#print("Right")
		_delay()
	
	if Input.is_action_pressed("Attack") and last_used == 2 and attack_delay == false:
		attack_delay = true
		rotation -= (PI)
		$weaponsprite/Sprite2D5.flip_v = 1
		$weaponsprite/Sprite2D6.flip_v = 1
		$attack_box.position.x = 67.5
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
		$weaponsprite/Sprite2D5.flip_v = 0
		$weaponsprite/Sprite2D6.flip_v = 0
		rotation += (PI)
		#print("Left")
		_delay()
	
	if Input.is_action_pressed("Attack") and last_used == -1 and attack_delay == false:
		attack_delay = true
		$attack_box.position = Vector2(79.5,0)
		rotation -= (PI/2)
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		rotation += (PI/2)
		$attack_box.position = Vector2(12,0)
		#print("Up")
		_delay()
		
	#attack down
	if Input.is_action_pressed("Attack") and last_used == -2 and attack_delay == false:
		attack_delay = true
		rotation += (PI/2)
		$attack_box.position = Vector2(79.5,0)
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		$attack_box.position = Vector2(12,0)
		rotation -= (PI/2)
		#print("Down")
		_delay()

func _on_attack_box_body_exited(body: Node2D) -> void:
	if body.get_node("Health_Manager") != null:
		if Input.is_action_pressed("Kill") == true:
			body.get_node("Health_Manager").Damage(dmg * 1000)
			print("OVERKILL")
		else:
			body.get_node("Health_Manager").Damage(dmg)
			print(dmg)
