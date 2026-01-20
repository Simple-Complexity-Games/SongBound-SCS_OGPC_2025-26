extends Area2D

var in_area = false

func _on_body_entered(body: Node2D) -> void:
	body.get_node("Health_Manager").Damage(5)
