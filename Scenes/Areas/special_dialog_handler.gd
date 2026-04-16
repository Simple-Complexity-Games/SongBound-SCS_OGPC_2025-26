extends Node2D

var stage = 0

func _process(delta: float) -> void:
	if stage == 0:
		get_parent().get_node("Dialog_Trigger_Swallow_1").get_node("Area2D").get_node("CollisionShape2D").disabled = false
		get_parent().get_node("Dialog_Trigger_Swallow_2").get_node("Area2D").get_node("CollisionShape2D").disabled = true
	elif stage == 1:
		

func _on_first_dialog_finished():
	stage = 1

func _on_fox_killed():
	stage = 2

func _on_dialog_trigger_swallow_1_dialog_finished() -> void:
	stage = 1
