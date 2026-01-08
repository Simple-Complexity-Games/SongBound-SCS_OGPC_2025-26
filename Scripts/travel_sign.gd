extends Node2D
	
@export var travelsign = {0:"res://Scenes/Areas/world.tscn"}

var is_in_area = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Up") and is_in_area:
		get_tree().change_scene_to_file(travelsign.get(0))


func _on_area_2d_body_entered(body: Node2D) -> void:
	is_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	is_in_area = false
