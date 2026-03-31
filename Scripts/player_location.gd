extends Node2D


# Called when the node enters the scene tree for the first time.
func change_location() -> void:
	get_parent().get_node("Player").global_position.x = GameManager.pos_x
	get_parent().get_node("Player").global_position.y = GameManager.pos_y
