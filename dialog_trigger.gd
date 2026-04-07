extends Node2D

@onready var player_detection_box = get_node("Area2D")

@export var dialog_file_name = ""

var dialog_folder_path = "res://Assets/Dialog/"
var dialog_list = {}

var player_in_area = false


func _ready():
	if FileAccess.file_exists(dialog_folder_path + dialog_file_name):
		var text_file = FileAccess.get_file_as_string(dialog_folder_path + dialog_file_name)
	

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_area = false
