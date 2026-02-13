extends Node2D

@export var travel_sign = {0 : "res://Scenes/Areas/world.tscn"}
@export var sign_text = "World"
@export var connected_sign_name = "put here"
var is_in_area = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Up") and is_in_area:
		get_tree().change_scene_to_file(travel_sign.get(0))

func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_in_area = true
	get_parent().get_node("CanvasLayer").Show_Text(sign_text)
func _on_area_2d_body_exited(_body: Node2D) -> void:
	is_in_area = false
	get_parent().get_node("CanvasLayer").Hide_Text()
