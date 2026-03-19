extends Area2D
@export var meh = 0
@export var hem = 0
var in_area = false

func _on_body_entered(body: Node2D) -> void:
	body.get_node("Health_Manager").Damage(meh)
	body.get_node("Health_Manager").Heal(hem)
