extends Control

@onready var Music_Player = get_node("Music_Player")
@onready var Hover_SFX_Player = get_node("Hover_SFX_Player")
# Main menu
@onready var Main_Menu_Container = get_node("Main_Menu_Container")
@onready var Start_Button = get_node("Main_Menu_Container/Start_Button")
@onready var Options_Button = get_node("Main_Menu_Container/Options_Button")
@onready var Quit_Button = get_node("Main_Menu_Container/Quit_Button")

# Options menu
@onready var Options_Menu_Container = get_node("Options_Menu_Container")
@onready var Controls_Button = get_node("Options_Menu_Container/Controls_Button")
@onready var Audio_Button = get_node("Options_Menu_Container/Audio_Button")
@onready var video_Button = get_node("Options_Menu_Container/Video_Button")
@onready var Back_Button = get_node("Options_Menu_Container/Back_Button")

#Audio Menu
@onready var Audio_Menu_Container = get_node("Audio_Menu_Container")

func _ready() -> void:
	Load_Main_Menu()

func _process(delta) -> void:
	if Music_Player.playing == false:
		Music_Player.playing = true
	
	if Input.is_action_just_pressed("Esc"):
		Load_Main_Menu()


# -----Main Menu-----
# Start button
func _on_start_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_start_button_button_down() -> void:
	Start_Game()
# Options button
func _on_options_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_options_button_button_down() -> void:
	Load_Options_Menu()
# Quit button
func _on_quit_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_quit_button_button_down() -> void:
	get_tree().quit()

# -----Options Menu-----
# Controls button
func _on_controls_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_controls_button_button_down() -> void:
	Load_Controls_Menu()
# Audio button
func _on_audio_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_audio_button_button_down() -> void:
	Load_Audio_Menu()
# Video button
func _on_video_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_video_button_button_down() -> void:
	Load_Video_Menu()

func _on_done_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_done_button_button_down() -> void:
	Load_Main_Menu()
	
	
	
	# -----Audio Menu-----
	
func _on_back_button_audio_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_back_button_audio_button_down() -> void:
	Load_Main_Menu()



func Start_Game():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func Load_Main_Menu():
	Options_Menu_Container.hide()
	Audio_Menu_Container.hide()
	Main_Menu_Container.show()

func Load_Options_Menu():
	Main_Menu_Container.hide()
	Options_Menu_Container.show()

func Load_Controls_Menu():
	pass

func Load_Audio_Menu():
	Options_Menu_Container.hide()
	Audio_Menu_Container.show()
	
func Load_Video_Menu():
	pass
