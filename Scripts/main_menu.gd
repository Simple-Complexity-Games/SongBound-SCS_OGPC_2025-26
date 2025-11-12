extends Control

@onready var Music_Player = get_node("Music_Player")
@onready var Hover_SFX_Player = get_node("Hover_SFX_Player")
@onready var Start_Button = get_node("VBoxContainer/Start_Button")
@onready var Options_Button = get_node("VBoxContainer/Options_Button")
@onready var Quit_Button = get_node("VBoxContainer/Quit_Button")

func _ready() -> void:
	Music_Player.playing = true

func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_start_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true

func _on_options_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true

func _on_quit_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
