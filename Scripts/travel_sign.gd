extends Node2D

@export var travel_sign = {0 : "res://Scenes/Areas/world.tscn"}
@export var sign_text = "World"
@export var connected_sign_pos_x = 0
@export var connected_sign_pos_y = 0

var is_in_area = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Up") and is_in_area == true:
		GameManager.pos_x = connected_sign_pos_x
		GameManager.pos_y = connected_sign_pos_y
		get_tree().change_scene_to_file(travel_sign.get(0))

func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_in_area = true
	GameManager.pos_x = connected_sign_pos_x
	GameManager.pos_y = connected_sign_pos_y
	get_parent().get_node("CanvasLayer").Show_Text(sign_text)
	$Notification.show()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	is_in_area = false
	$Notification.hide()
	get_parent().get_node("CanvasLayer").Hide_Text()
	await get_tree().create_timer(.002).timeout
	GameManager.pos_x = position.x
	GameManager.pos_y = position.y
