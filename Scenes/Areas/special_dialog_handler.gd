extends Node2D

@onready var Giant_Fox = get_parent().get_node("Giant_Fox")

var stage = 0

func _process(delta: float) -> void:
	if stage == 0:
		Giant_Fox.position = Vector2(4536.0, 100.0)
		Giant_Fox.velocity = Vector2(0, 0)
		get_parent().get_node("Dialog_Trigger_Swallow_1").get_node("Area2D").get_node("CollisionShape2D").disabled = false
		get_parent().get_node("Dialog_Trigger_Swallow_2").get_node("Area2D").get_node("CollisionShape2D").disabled = true
	elif stage == 1:
		pass
	elif stage == 2:
		get_parent().get_node("Dialog_Trigger_Swallow_1").get_node("Area2D").get_node("CollisionShape2D").disabled = true
		get_parent().get_node("Dialog_Trigger_Swallow_2").get_node("Area2D").get_node("CollisionShape2D").disabled = false

func _on_dialog_trigger_swallow_1_dialog_finished() -> void:
	stage = 1

func _on_dialog_trigger_swallow_2_dialog_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/Areas/main_menu.tscn")

func _on_giant_fox_slain() -> void:
	stage = 2
