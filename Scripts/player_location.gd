extends Node2D

func _ready() -> void:
	get_parent().get_node("Player").global_position.x = GameManager.pos_x
	get_parent().get_node("Player").global_position.y = GameManager.pos_y


func change_location() -> void:
	get_parent().get_node("Player").global_position.x = GameManager.pos_x
	get_parent().get_node("Player").global_position.y = GameManager.pos_y
