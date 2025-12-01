extends Control

@onready var Music_Player = get_node("Music_Player")
@onready var Hover_SFX_Player = get_node("Hover_SFX_Player")
# Main menu
@onready var Main_Menu_Container = get_node("Main_Menu_Container")
@onready var Main_Menu_Label = get_node("Title_Label")
@onready var Options_Menu_Container = get_node("Options_Menu_Container")
@onready var Options_Menu_Label = get_node("Options_Menu_Label")
@onready var Controls_Menu_Container = get_node("Controls_Menu_Container")
@onready var Left_Bind_1 = get_node("Controls_Menu_Container/GridContainer/Left_Bind_Button/Left_Container/Left_Bind_1")
@onready var Left_Bind_2 = get_node("Controls_Menu_Container/GridContainer/Left_Bind_Button/Left_Container/Left_Bind_2")
@onready var Right_Bind_1 = get_node("Controls_Menu_Container/GridContainer/Right_Bind_Button/Right_Container/Right_Bind_1")
@onready var Right_Bind_2 = get_node("Controls_Menu_Container/GridContainer/Right_Bind_Button/Right_Container/Right_Bind_2")
@onready var Up_Bind_1 = get_node("Controls_Menu_Container/GridContainer/Up_Bind_Button/Up_Container/Up_Bind_1")
@onready var Up_Bind_2 = get_node("Controls_Menu_Container/GridContainer/Up_Bind_Button/Up_Container/Up_Bind_2")
@onready var Down_Bind_1 = get_node("Controls_Menu_Container/GridContainer/Down_Bind_Button/Down_Container/Down_Bind_1")
@onready var Down_Bind_2 = get_node("Controls_Menu_Container/GridContainer/Down_Bind_Button/Down_Container/Down_Bind_2")
@onready var Jump_Bind_1 = get_node("Controls_Menu_Container/GridContainer/Jump_Bind_Button/Jump_Container/Jump_Bind_1")
@onready var Jump_Bind_2 = get_node("Controls_Menu_Container/GridContainer/Jump_Bind_Button/Jump_Container/Jump_Bind_2")
@onready var Glide_Bind_1 = get_node("Controls_Menu_Container/GridContainer/Glide_Bind_Button/Glide_Container/Glide_Bind_1")
@onready var Glide_Bind_2 = get_node("Controls_Menu_Container/GridContainer/Glide_Bind_Button/Glide_Container/Glide_Bind_2")
@onready var Audio_Menu_Container = get_node("Audio_Menu_Container")
@onready var Audio_Menu_Label = get_node("Audio_Menu_Label")
@onready var Master_Volume_Slider = get_node("Audio_Menu_Container/Master_Volume_Slider")
@onready var Music_Volume_Slider = get_node("Audio_Menu_Container/Music_Volume_Slider")
@onready var SFX_Volume_Slider = get_node("Audio_Menu_Container/SFX_Volume_Slider")
@onready var Video_Menu_Container = get_node("Video_Menu_Container")
@onready var Video_Menu_Label = get_node("Video_Menu_Label")
@onready var Video_Brightness_Slider = get_node("Video_Menu_Container/Brightness_Slider")
@onready var Video_Contrast_Slider = get_node("Video_Menu_Container/Contrast_Slider")
@onready var Video_Saturation_Slider = get_node("Video_Menu_Container/Saturation_Slider")
@onready var Screen_Shake_Button = get_node("Video_Menu_Container/Screen_Shake_Button")
@onready var Screen_Blur_Button = get_node("Video_Menu_Container/Screen_Blur_Button")
@onready var Window_Mode_Button = get_node("Video_Menu_Container/Window_Mode_Button")
@onready var World_Environment = get_node("WorldEnvironment")

# rebinding status var
var start_rebinding = false
var rebinding = false
var action_to_be_rebound: String
# Dictionaries to get an icon node during rebinding using the action_to_be_rebound var
var Rebind_Action_To_Primary_Icon_Node_Dict = {}
var Rebind_Action_To_Secondary_Icon_Node_Dict = {}
# Dictionary to get the icon for a key by keycode
var Keycode_To_Key_Icon_Dict = {}
var Mouse_Index_To_Button_Icon_Dict = {}

# Window mode button dictionary for relating indexes and window modes
var Window_Mode_Index_Dict = {0:DisplayServer.WINDOW_MODE_FULLSCREEN, 
1:DisplayServer.WINDOW_MODE_MAXIMIZED, 2:DisplayServer.WINDOW_MODE_WINDOWED}
var Button_To_WindowMode_Index_Dict = {0:3, 1:2, 2:0}
var unsupported_window_modes = [DisplayServer.WINDOW_MODE_MINIMIZED, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]

var previous_window_mode = DisplayServer.WINDOW_MODE_MAXIMIZED

# Config file
var config = ConfigFile.new()
var autosave_timer = null

func _ready() -> void:
	Load_Main_Menu()
	
	if !FileAccess.file_exists("user://config"):
		Create_Config(config)
		Save_Config(config)
	else:
		config.load("user://config")
		Apply_Config(config)
	
	# This dict has to be defined in _ready() because it contains @onready vars which are not loaded until then
	Rebind_Action_To_Primary_Icon_Node_Dict = {"Left":Left_Bind_1, "Right":Right_Bind_1, 
	"Up":Up_Bind_1, "Down":Down_Bind_1, "Jump":Jump_Bind_1, "Glide":Glide_Bind_1}
	Rebind_Action_To_Secondary_Icon_Node_Dict = {"Left":Left_Bind_2, "Right":Right_Bind_2, 
	"Up":Up_Bind_2, "Down":Down_Bind_2, "Jump":Jump_Bind_2, "Glide":Glide_Bind_2}

func _process(delta) -> void:
	if Music_Player.playing == false:
		Music_Player.playing = true
	
	if Input.is_action_just_pressed("Escape"):
		if Options_Menu_Container.visible == false and Main_Menu_Container.visible == false:
			Load_Options_Menu()
		elif Options_Menu_Container.visible == true:
			Load_Main_Menu()
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			previous_window_mode = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Window_Mode_Button.selected = Window_Mode_Index_Dict.find_key(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Change_Override_Config("display/window/size/mode", DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(previous_window_mode)
			if Window_Mode_Index_Dict.has(previous_window_mode):
				Window_Mode_Button.selected = Window_Mode_Index_Dict.find_key(previous_window_mode)
				Change_Override_Config("display/window/size/mode", previous_window_mode)
	
	if DisplayServer.window_get_mode() != previous_window_mode and DisplayServer.window_get_mode() not in unsupported_window_modes and DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		Window_Mode_Button.selected = Window_Mode_Index_Dict.find_key(DisplayServer.window_get_mode())
		Change_Override_Config("display/window/size/mode", DisplayServer.window_get_mode())
		previous_window_mode = DisplayServer.window_get_mode()
	
	# Autosave functionality logic
	if autosave_timer == null:
		var autosave_timer = get_tree().create_timer(180, false, true)
	elif autosave_timer.time_left <= 0:
		Save_Config(config)
		var autosave_timer = get_tree().create_timer(180, false, true)


# -------------------------------------------------Main Menu Functions-----
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


# -------------------------------------------------Options Menu Functions-----
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


# -------------------------------------------------Controls Menu Functions-----
# Left action rebind button
func _on_left_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_left_bind_button_button_down():
	Hover_SFX_Player.playing = true
	start_rebinding = true
	action_to_be_rebound = "Left"
# Right action rebind button
func _on_right_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_right_bind_button_button_down():
	Hover_SFX_Player.playing = true
# Up action rebind button
func _on_up_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_up_bind_button_button_down():
	Hover_SFX_Player.playing = true
# Down action rebind button
func _on_down_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_down_bind_button_button_down():
	Hover_SFX_Player.playing = true
# Jump action rebind button
func _on_jump_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_jump_bind_button_button_down():
	Hover_SFX_Player.playing = true
# Glide action rebind button
func _on_glide_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_glide_bind_button_button_down():
	Hover_SFX_Player.playing = true
# Done button
func _on_controls_done_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_controls_done_button_button_down():
	Save_Config(config)
	Load_Options_Menu()

func Listen_For_Rebind(binding_slot_icon):
	#print("ryretg")
	#print(Input.is_anything_just_pressed())
	#while not Input.is_anything_pressed():
		#print("rebinding!")
		#binding_slot_icon.modulate = Color("red")
	#binding_slot_icon.modulate.v = 1
	pass

func _input(event):
	# Only rebind controls if the rebinding flag has been set to true
	if rebinding and event.is_action_type() and !event.is_echo():
		if event is InputEventMouseButton:
			print("m",event.button_index)
			# Set secondary rebind slot icon to the primary slot's old image to make room for the new bind
			Rebind_Action_To_Secondary_Icon_Node_Dict.get(action_to_be_rebound).texture = Rebind_Action_To_Primary_Icon_Node_Dict.get(action_to_be_rebound).texture
			Rebind_Action_To_Primary_Icon_Node_Dict.get(action_to_be_rebound).texture = Mouse_Index_To_Button_Icon_Dict.get("m"+str(event.button_index))
			Update_Config("Controls", action_to_be_rebound, Get_Config("Controls", action_to_be_rebound, 0), 1)
			Update_Config("Controls", action_to_be_rebound, "m"+str(event.button_index), 0)
			rebinding = false
		elif event is InputEventKey:
			if event.is_pressed() == true:
				print(event.keycode)
				Update_Config("Controls", action_to_be_rebound, event.keycode, 0)
				rebinding = false
		# Bring icon back to normal value to show rebinding is finished
		Rebind_Action_To_Secondary_Icon_Node_Dict.get(action_to_be_rebound).modulate.v = 1
		# Set the input as handled so it doesn't effect anything else in game
		get_viewport().set_input_as_handled()
	# Ignore the first input when rebinding button is pressed, enabling the next input to be the one bound, 
	# because otherwise the action will just be rebound to the button pressed to initiate the rebind 
	# as even though it is handled already by the rebind button this is input and it doesn't care about that.
	elif start_rebinding: 
		start_rebinding = false
		rebinding = true
		
		# Grey out action icon to show rebinding has started
		Rebind_Action_To_Secondary_Icon_Node_Dict.get(action_to_be_rebound).modulate.v = 0.5


# -------------------------------------------------Audio Menu Functions-----
# Master volume slider
func _on_master_volume_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_master_volume_slider_value_changed(value):
	Hover_SFX_Player.playing = true
	AudioServer.set_bus_volume_linear(0, value * 2)
func _on_master_volume_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Audio", "Master_Volume", Master_Volume_Slider.value)
# Music volume slider
func _on_music_volume_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_music_volume_slider_value_changed(value):
	Hover_SFX_Player.playing = true
	AudioServer.set_bus_volume_linear(1, value)
func _on_music_volume_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Audio", "Music_Volume", Music_Volume_Slider.value)
# SFX volume slider
func _on_sfx_volume_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_sfx_volume_slider_value_changed(value):
	Hover_SFX_Player.playing = true
	AudioServer.set_bus_volume_linear(2, value)
func _on_sfx_volume_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Audio", "SFX_Volume", SFX_Volume_Slider.value)
# Done button
func _on_audio_done_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_audio_done_button_button_down() -> void:
	Save_Config(config)
	Load_Options_Menu()


# -------------------------------------------------Video Menu Functions-----
# Brightness slider
func _on_brightness_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_brightness_slider_value_changed(value):
	Hover_SFX_Player.playing = true
	World_Environment.environment.adjustment_brightness = value
func _on_brightness_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Video", "Brightness", Video_Brightness_Slider.value)
# Contrast slider
func _on_contrast_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_contrast_slider_value_changed(value):
	World_Environment.environment.adjustment_contrast = value
	Hover_SFX_Player.playing = true
func _on_contrast_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Video", "Contrast", Video_Contrast_Slider.value)
# Saturation slider
func _on_saturation_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_saturation_slider_value_changed(value):
	World_Environment.environment.adjustment_saturation = value
	Hover_SFX_Player.playing = true
func _on_saturation_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Video", "Saturation", Video_Saturation_Slider.value)
# Screen shake button
func _on_screen_shake_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_screen_shake_button_button_down():
	Update_Config("Video", "Screen_Shake", !config.get_value("Video", "Screen_Shake"))
# Screen blur button
func _on_screen_blur_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_screen_blur_button_button_down():
	Update_Config("Video", "Screen_Blur", !config.get_value("Video", "Screen_Blur"))
# Window mode button
func _on_window_mode_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_window_mode_button_item_selected(index):
	Change_Override_Config("display/window/size/mode", Button_To_WindowMode_Index_Dict.get(index))
	DisplayServer.window_set_mode(Window_Mode_Index_Dict.get(index))
# Done button
func _on_video_done_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_video_done_button_button_down() -> void:
	Save_Config(config)
	Load_Options_Menu()


# -------------------------------------------------Other / Load Functions-----
func Start_Game():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

# Save settings upon quitting application at window manager request
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Save_Config(config)

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


# -------------------------------------------------Config Functions-----

func Create_Config(config):
	# Set audio default values
	config.set_value("Audio", "Master_Volume", 80)
	config.set_value("Audio", "Music_Volume", 80)
	config.set_value("Audio", "SFX_Volume", 80)
	# Set video default values
	config.set_value("Video", "Brightness", 1)
	config.set_value("Video", "Contrast", 1)
	config.set_value("Video", "Saturation", 1)
	config.set_value("Video", "Window_Mode", 0)
	config.set_value("Video", "Screen_Shake", false)
	config.set_value("Video", "Screen_Blur", false)
	# Set controls default values
	config.set_value("Controls", "Left", ["0", "0"])
	config.set_value("Controls", "Right", ["0", "0"])
	config.set_value("Controls", "Up", ["0", "0"])
	config.set_value("Controls", "Down", ["0", "0"])
	config.set_value("Controls", "Jump", ["0", "0"])
	config.set_value("Controls", "Glide", ["0", "0"])

func Get_Config(section, key, index = null):
	if index != null:
		var list = config.get_value(section, key)
		return list[index]
	else:
		return config.get_value(section, key)

func Update_Config(section, key, value, index = null):
	if index != null:
		var list = config.get_value(section, key)
		list[index] = value
		config.set_value(section, key, list)
	else:
		config.set_value(section, key, value)

func Change_Override_Config(setting_path, value):
	ProjectSettings.set_setting(setting_path, value)
	ProjectSettings.save_custom("override.cfg")

func Save_Config(config):
	config.save("user://config")

func Apply_Config(config):
	# <> Controls settings
	
	# Audio settings
	AudioServer.set_bus_volume_linear(0, config.get_value("Audio", "Master_Volume"))
	Master_Volume_Slider.value = AudioServer.get_bus_volume_linear(0)
	AudioServer.set_bus_volume_linear(1, config.get_value("Audio", "Music_Volume"))
	Music_Volume_Slider.value = config.get_value("Audio", "Music_Volume")
	AudioServer.set_bus_volume_linear(2, config.get_value("Audio", "SFX_Volume"))
	SFX_Volume_Slider.value = config.get_value("Audio", "SFX_Volume")
	
	# Video settings
	World_Environment.environment.adjustment_brightness = config.get_value("Video", "Brightness")
	Video_Brightness_Slider.value = World_Environment.environment.adjustment_brightness
	World_Environment.environment.adjustment_contrast = config.get_value("Video", "Contrast")
	Video_Contrast_Slider.value = World_Environment.environment.adjustment_contrast
	World_Environment.environment.adjustment_saturation = config.get_value("Video", "Saturation")
	Video_Saturation_Slider.value = World_Environment.environment.adjustment_saturation
	# Screen shake and blur
	Screen_Shake_Button.button_pressed = config.get_value("Video", "Screen_Shake")
	Screen_Blur_Button.button_pressed = config.get_value("Video", "Screen_Blur")
	# Window setting
	Window_Mode_Button.selected = Button_To_WindowMode_Index_Dict.find_key(ProjectSettings.get_setting_with_override("display/window/size/mode"))
