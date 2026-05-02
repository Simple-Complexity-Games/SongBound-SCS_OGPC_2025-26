extends Node2D

@onready var Giant_Fox = get_parent().get_node("Giant_Fox")

var stage = 0

func _ready() -> void:
	if FileAccess.file_exists("user://fox_spawned.txt"):
		stage = 1
	elif FileAccess.file_exists("user://fox_killed.txt"):
		stage = 2

func _process(delta: float) -> void:
	if stage == 0:
		Giant_Fox.position = Vector2(4536.0, 100.0)
		Giant_Fox.velocity = Vector2(0, 0)
		get_parent().get_node("Dialog_Trigger_Swallow_1").get_node("Area2D").get_node("CollisionShape2D").disabled = false
		get_parent().get_node("Dialog_Trigger_Swallow_2").get_node("Area2D").get_node("CollisionShape2D").disabled = true
	elif stage == 1:
		if not FileAccess.file_exists("user://fox_spawned.txt"):
			# Create fox_spawned file as a way to store spawn state
			var fox_file = FileAccess.open("user://fox_spawned.txt", FileAccess.WRITE)
			fox_file.store_string("a")
			fox_file.close()
	elif stage == 2:
		if Giant_Fox != null:
			Giant_Fox.position = Vector2(4536.0, 100.0)
			Giant_Fox.velocity = Vector2(0, 0)
		get_parent().get_node("Dialog_Trigger_Swallow_1").get_node("Area2D").get_node("CollisionShape2D").disabled = true
		get_parent().get_node("Dialog_Trigger_Swallow_2").get_node("Area2D").get_node("CollisionShape2D").disabled = false

func _on_dialog_trigger_swallow_1_dialog_finished() -> void:
	stage = 1
	Giant_Fox.Alert = false

func _on_dialog_trigger_swallow_2_dialog_finished() -> void:
	var dir_access = DirAccess.open("user://")
	if FileAccess.file_exists("user://fox_killed.txt"):
		dir_access.remove("user://fox_killed.txt")
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")

func _on_giant_fox_slain() -> void:
	var dir_access = DirAccess.open("user://")
	if FileAccess.file_exists("user://fox_spawned.txt"):
		dir_access.remove("user://fox_spawned.txt")
	if not FileAccess.file_exists("user://fox_killed.txt"):
		# Create fox_killed file as a way to store kill state
		var fox_killed_file = FileAccess.open("user://fox_killed.txt", FileAccess.WRITE)
		fox_killed_file.store_string("a")
		fox_killed_file.close()
	stage = 2
