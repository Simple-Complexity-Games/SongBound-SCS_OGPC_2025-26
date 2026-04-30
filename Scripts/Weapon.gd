extends Node2D

@export var dmg = 25
var last_used = 0
var attack_delay = false
var no_angle_change = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shaft.hide()
	position.y = -12

func _delay():
	await get_tree().create_timer(.5555555).timeout
	attack_delay = false

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("Right"):
		if no_angle_change == false:
			last_used = 1
			rotation = 0
	if Input.is_action_pressed("Left"):
		if no_angle_change == false:
			last_used = 2
			rotation = -(PI)
	if Input.is_action_pressed("Up"):
		if no_angle_change == false:
			last_used = -1
			rotation = -(PI/2)
	if Input.is_action_pressed("Down"):
		if no_angle_change == false:
			last_used = -2
			rotation = (PI/2)
	#attack right
	if Input.is_action_pressed("Attack") and last_used == 1 and attack_delay == false:
		attack_delay = true
		no_angle_change = true
		$Shaft.show()
		$Shaft.position.x -= 5
		await get_tree().create_timer(.03333).timeout
		$Shaft.rotation = deg_to_rad(-4.8)
		$Shaft.position.x = 11
		var tween = get_tree().create_tween()
		tween.tween_property($Shaft,"rotation",deg_to_rad(4.8),.12495)
		tween.tween_property($Shaft,"position:x",-3,.12495)
		$attack_box.position.x = 67.5
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.12495).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.12495).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.12495).timeout
		$attack_box/right.set_deferred("disabled", true)
		$Shaft.hide()
		no_angle_change = false
		$Shaft.position.x = 0
		$Shaft.rotation = 0
		$attack_box.position.x = 0
		#print("Right")
		_delay()
	
	if Input.is_action_pressed("Attack") and last_used == 2 and attack_delay == false:
		attack_delay = true
		no_angle_change = true
		$Shaft/Blade.flip_v = -1
		$Shaft.show()
		$Shaft.position.x -= 5
		await get_tree().create_timer(.03333).timeout
		$Shaft.rotation = deg_to_rad(4.8)
		$Shaft.position.x = 11
		var tween = get_tree().create_tween()
		tween.tween_property($Shaft,"rotation",deg_to_rad(-4.8),.12495)
		tween.tween_property($Shaft,"position:x",3,.12495)
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
		$Shaft.hide()
		no_angle_change = false
		$attack_box.position.x = 0
		$Shaft.position.x = 0
		$Shaft.rotation = 0
		$Shaft/Blade.flip_v = 0
		#print("Left")
		_delay()
	
	if Input.is_action_pressed("Attack") and last_used == -1 and attack_delay == false:
		attack_delay = true
		no_angle_change = true
		$attack_box.position = Vector2(67.5,0)
		$Shaft.show()
		$Shaft.position.x -= 5
		await get_tree().create_timer(.03333).timeout
		$Shaft.rotation = deg_to_rad(-4.8)
		$Shaft.position.x = 11
		var tween = get_tree().create_tween()
		tween.tween_property($Shaft,"rotation",deg_to_rad(4.8),.12495)
		tween.tween_property($Shaft,"position:x",-3,.12495)
		$attack_box/left.set_deferred("disabled", false)
		await get_tree().create_timer(.1666).timeout
		$attack_box/midle.set_deferred("disabled", false)
		$attack_box/left.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", false)
		$attack_box/midle.set_deferred("disabled", true)
		await get_tree().create_timer(.1666).timeout
		$attack_box/right.set_deferred("disabled", true)
		$Shaft.hide()
		no_angle_change = false
		$Shaft.position.x = 0
		$Shaft.rotation = 0
		$attack_box.position = Vector2(12,0)
		#print("Up")
		_delay()
		
	#attack down
	if Input.is_action_pressed("Attack") and last_used == -2 and attack_delay == false:
		attack_delay = true
		no_angle_change = true
		$Shaft.show()
		$Shaft.position.x -= 5
		await get_tree().create_timer(.03333).timeout
		$Shaft.rotation = deg_to_rad(-4.8)
		$Shaft.position.x = 11
		var tween = get_tree().create_tween()
		tween.tween_property($Shaft,"rotation",deg_to_rad(4.8),.12495)
		tween.tween_property($Shaft,"position:x",-3,.12495)
		$attack_box.position = Vector2(67.5,0)
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
		$Shaft.hide()
		no_angle_change = false
		$Shaft.position.x = 0
		$Shaft.rotation = 0
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
