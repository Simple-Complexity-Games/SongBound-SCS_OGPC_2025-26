extends Control

@onready var Music_Player = get_node("Music_Player")
@onready var Hover_SFX_Player = get_node("Hover_SFX_Player")
# Main menu
@onready var Main_Menu_Container = get_node("Main_Menu_Container")
@onready var Main_Menu_Label = get_node("Title_Label")
@onready var Options_Menu_Container = get_node("Options_Menu_Container")
@onready var Options_Menu_Label = get_node("Options_Menu_Label")
@onready var Controls_Menu_Container = get_node("Controls_Menu_Container")
@onready var Audio_Menu_Container = get_node("Audio_Menu_Container")
@onready var Audio_Menu_Label = get_node("Audio_Menu_Label")
@onready var Video_Menu_Container = get_node("Video_Menu_Container")
@onready var Video_Menu_Label = get_node("Video_Menu_Label")
@onready var Video_Brightness_Slider = get_node("Video_Menu_Container/Brightness_Slider")
@onready var Video_Contrast_Slider = get_node("Video_Menu_Container/Contrast_Slider")
@onready var Video_Saturation_Slider = get_node("Video_Menu_Container/Saturation_Slider")
@onready var Window_Mode_Button = get_node("Video_Menu_Container/Window_Mode_Button")
@onready var World_Environment = get_node("WorldEnvironment")

# Window mode button dictionary for relating indexes and window modes
var Window_Mode_Index_Dict = {0:DisplayServer.WINDOW_MODE_FULLSCREEN, 1:DisplayServer.WINDOW_MODE_MAXIMIZED,
2:DisplayServer.WINDOW_MODE_WINDOWED}

var previous_window_mode = DisplayServer.WINDOW_MODE_MAXIMIZED

# Config file container
var config


func _ready() -> void:
	Load_Main_Menu()
	
	if !FileAccess.file_exists("user://config"):
		Create_Config(config)
	else:
		config.load("user://config")
		Apply_Config(config)

func _process(delta) -> void:
	if Music_Player.playing == false:
		Music_Player.playing = true
	
	if Input.is_action_just_pressed("Esc"):
		if Options_Menu_Container.visible == false and Main_Menu_Container.visible == false:
			Load_Options_Menu()
		elif Options_Menu_Container.visible == true:
			Load_Main_Menu()
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			previous_window_mode = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Window_Mode_Button.selected = Window_Mode_Index_Dict.find_key(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(previous_window_mode)
			if Window_Mode_Index_Dict.has(previous_window_mode):
				Window_Mode_Button.selected = Window_Mode_Index_Dict.find_key(previous_window_mode)
	if DisplayServer.window_get_mode() != previous_window_mode and DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		Window_Mode_Button.selected = Window_Mode_Index_Dict.find_key(DisplayServer.window_get_mode())
		previous_window_mode = DisplayServer.window_get_mode()


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
# Done button
func _on_done_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_done_button_button_down() -> void:
	Load_Main_Menu()
	

# -----Controls Menu-----
func _on_controls_done_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_controls_done_button_button_down():
	Load_Options_Menu()

# -----Audio Menu-----
# Done button
func _on_audio_done_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_audio_done_button_button_down() -> void:
	Load_Options_Menu()
	
	# -----Video Menu-----
# Brightness slider
func _on_brightness_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_brightness_slider_value_changed(value):
	World_Environment.environment.adjustment_brightness = value
	Hover_SFX_Player.playing = true
func _on_contrast_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_contrast_slider_value_changed(value):
	World_Environment.environment.adjustment_contrast = value
	Hover_SFX_Player.playing = true
func _on_saturation_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_saturation_slider_value_changed(value):
	World_Environment.environment.adjustment_saturation = value
	Hover_SFX_Player.playing = true
# Screen shake button
func _on_screen_shake_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_screen_shake_button_button_down():
	pass
# Screen blur button
func _on_screen_blur_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_screen_blur_button_button_down():
	pass
# Done button
func _on_video_done_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_video_done_button_button_down() -> void:
	Load_Options_Menu()
func _on_window_mode_button_item_selected(index):
	DisplayServer.window_set_mode(Window_Mode_Index_Dict.get(index))




func Start_Game():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func Load_Main_Menu():
	Options_Menu_Container.hide()
	Options_Menu_Label.hide()
	Controls_Menu_Container.hide()
	Audio_Menu_Container.hide()
	Audio_Menu_Label.hide()
	Video_Menu_Container.hide()
	Video_Menu_Label.hide()
	Main_Menu_Container.show()
	Main_Menu_Label.show()

func Load_Options_Menu():
	Main_Menu_Container.hide()
	Main_Menu_Label.hide()
	Controls_Menu_Container.hide()
	Audio_Menu_Container.hide()
	Audio_Menu_Label.hide()
	Video_Menu_Container.hide()
	Video_Menu_Label.hide()
	Options_Menu_Container.show()
	Options_Menu_Label.show()

func Load_Controls_Menu():
	Main_Menu_Container.hide()
	Main_Menu_Label.hide()
	Options_Menu_Container.hide()
	Options_Menu_Label.hide()
	Audio_Menu_Container.hide()
	Audio_Menu_Label.hide()
	Video_Menu_Container.hide()
	Video_Menu_Label.hide()
	Controls_Menu_Container.show()

func Load_Audio_Menu():
	Main_Menu_Container.hide()
	Main_Menu_Label.hide()
	Options_Menu_Container.hide()
	Options_Menu_Label.hide()
	Controls_Menu_Container.hide()
	Video_Menu_Container.hide()
	Video_Menu_Label.hide()
	Audio_Menu_Container.show()
	Audio_Menu_Label.show()
	
func Load_Video_Menu():
	Main_Menu_Container.hide()
	Main_Menu_Label.hide()
	Options_Menu_Container.hide()
	Options_Menu_Label.hide()
	Controls_Menu_Container.hide()
	Audio_Menu_Container.hide()
	Audio_Menu_Label.hide()
	Video_Menu_Container.show()
	Video_Menu_Label.show()


func Create_Config(config):
	config = ConfigFile.new()
	
	# Set audio default values
	config.set_value("Audio", "Master_Volume", 80)
	config.set_value("Audio", "Music_Volume", 80)
	config.set_value("Audio", "SFX_Volume", 80)
	# Set video default values
	config.set_value("Video", "Brightness", 1)
	config.set_value("Video", "Contrast", 1)
	config.set_value("Video", "Saturation", 1)
	config.set_value("Video", "Window_Mode", DisplayServer.WINDOW_MODE_FULLSCREEN)
	config.set_value("Video", "Screen_Shake", false)
	config.set_value("Video", "Screen_Blur", false)
	# Set controls default values
	config.set_value("Controls", "Left", 0)
	config.set_value("Controls", "Right", 0)
	config.set_value("Controls", "Up", 0)
	config.set_value("Controls", "Down", 0)
	config.set_value("Controls", "Jump", 0)
	config.set_value("Controls", "Glide", 0)
	
	Save_Config(config)

func Update_Config(section, key, value):
	config.set_value(section, key, value)
func Save_Config(config):
	config.save("user://config")

func Apply_Config(config):
	# Video settings
	World_Environment.environment.adjustment_brightness = config.get_value("Video", "Brightness")
	Video_Brightness_Slider.value = World_Environment.environment.adjustment_brightness
	World_Environment.environment.adjustment_contrast = config.get_value("Video", "Contrast")
	Video_Contrast_Slider.value = World_Environment.environment.adjustment_contrast
	World_Environment.environment.adjustment_saturation = config.get_value("Video", "Saturation")
	Video_Saturation_Slider.value = World_Environment.environment.adjustment_saturation
	
	DisplayServer.window_set_mode(config.get_value("Video", "Window_Mode"))
