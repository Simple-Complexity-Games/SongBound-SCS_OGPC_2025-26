extends Node2D

@onready var player_detection_box = get_node("Area2D")
@onready var dialog_box = get_parent().get_node("CanvasLayer").get_node("Dialog_Handler").get_node("Dialog_Box").get_node("Main_Textbox")

@export var dialog_file_name = ""

var dialog_folder_path = "res://Assets/Dialog/"
var file_loaded = false
var line_list = []
var next_line = 0
var dialog_box_hidden = true
var dialog_playing = false

var player_in_area = false


func _ready():
	var file_text = ""
	if FileAccess.file_exists(dialog_folder_path + dialog_file_name):
		file_text = FileAccess.get_file_as_string(dialog_folder_path + dialog_file_name)
		file_loaded = true
	else:
		print("ERROR: Dialog file '", dialog_file_name, "'does not exist")
	
	var line = ""
	for char in file_text:
		if char == "|":
			line_list.append(line)
			line = ""
		else:
			# Skip recording newlines at the beginning of new dialog lines because they are a common result of dialog file formatting for legibility but break the character icon name recognition dictionary. This is preferable to preprocessing the file and removing all \n characters because it preserves the ability to add stylistic newlines to dialog
			if not (line == "" and (char == "\n" or char == "\r")):
				line += char
			
	print(line_list)

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Up") or Input.is_action_just_pressed("Jump")) and player_in_area and file_loaded:
		print("sdfgdfhh")
		if dialog_box_hidden == true:
			print("show")
			dialog_box.get_parent().show()
			dialog_box_hidden = false
		
		print(dialog_playing)
		print(next_line)
		if next_line > (line_list.size() - 1) and not dialog_playing:
			print("hide")
			dialog_box.get_parent().hide()
			dialog_box_hidden = true
			dialog_box.clear()
			next_line = 0
		elif not dialog_playing:
			print("playing")
			dialog_playing = true
			dialog_box.Play_Line(line_list[next_line])
			next_line += 1
		else:
			dialog_box.skip_requested = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_in_area = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_in_area = false

func _on_main_textbox_done_printing() -> void:
	dialog_playing = false
