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

# Button icon folder
var button_icon_folder_path = "res://Assets/Art/Button_Icons/Keyboard_And_Mouse/Dark/"
# Unrecognized keybind texture paths
var blank_button_icon_folder_path = "res://Assets/Art/Button_Icons/Keyboard_And_Mouse/Blank/"
var blank_key_texture_name = "Blank_Black_Normal.png"
var blank_mouse_texture_name = "Blank_Black_Mouse.png"
# Rebinding status vars
var start_rebinding = false
var rebinding = false
var action_to_be_rebound: String
# Dictionaries to get an icon node during rebinding using the action_to_be_rebound var
var Rebind_Action_To_Primary_Icon_Node_Dict = {}
var Rebind_Action_To_Secondary_Icon_Node_Dict = {}

#region - Dictionaries of key/mouse button icon file names by keycode/mouse index, collapsed because of size
# Unfortunately we don't really have the time to implement a way to show the chirality (handedness) of 
# identical keys (shift, ctrl, alt, etc.). This is implemented in code, with a distinction between left 
# and right keys, but the icons will just not reflect that because the icon pack does not contain icons 
# for separate chiral keys and it would be too time consuming to add an extra indicator to the UI
var Keycode_To_Button_Icon_File_Name_Dict = {
8:"Backspace_Key_Dark.png", 
9:"Tab_Key_Dark.png", 
13:"Enter_Key_Dark.png", 
16:"Shift_Key_Dark.png",
17:"Ctrl_Key_Dark.png",
18:"Alt_Key_Dark.png",
20:"Caps_Lock_Key_Dark.png",
27:"Esc_Key_Dark.png",
32:"Space_Key_Dark.png",
33:"Page_Up_Key_Dark.png",
34:"Page_Down_Key_Dark.png",
35:"End_Key_Dark.png",
36:"Home_Key_Dark.png",
37:"Arrow_Left_Key_Dark.png",
38:"Up_Arrow_Key_Dark.png",
39:"Arrow_Right_Key_Dark.png",
40:"Arrow_Down_Key_Dark.png",
44:"Print_Screen_Key_Dark.png",
45:"Insert_Key_Dark.png",
46:"Del_Key_Dark.png",
48:"0_Key_Dark.png", 
49:"1_Key_Dark.png", 
50:"2_Key_Dark.png", 
51:"3_Key_Dark.png", 
52:"4_Key_Dark.png", 
53:"5_Key_Dark.png", 
54:"6_Key_Dark.png", 
55:"7_Key_Dark.png", 
56:"8_Key_Dark.png", 
57:"9_Key_Dark.png", 
65:"A_Key_Dark.png", # ----------- ALPHABET YAYYYY!! -------------
160:"Shift_Key_Dark.png", 
161:"Shift_Key_Dark.png", 
162:"Ctrl_Key_Dark.png", 
163:"Ctrl_Key_Dark.png", 
164:"Alt_Key_Dark.png", 
165:"Alt_Key_Dark.png"}
var Mouse_Index_To_Button_Icon_File_Name_Dict = {}
#endregion

# Window mode button dictionary for relating indexes and window modes
var Window_Mode_Index_Dict = {0:DisplayServer.WINDOW_MODE_FULLSCREEN, 
1:DisplayServer.WINDOW_MODE_MAXIMIZED, 2:DisplayServer.WINDOW_MODE_WINDOWED}
var Button_To_WindowMode_Index_Dict = {0:3, 1:2, 2:0}
var unsupported_window_modes = [DisplayServer.WINDOW_MODE_MINIMIZED, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN]

var previous_window_mode = DisplayServer.WINDOW_MODE_MAXIMIZED
var previous_window_size = Vector2()

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
	
	previous_window_size = DisplayServer.window_get_size()

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
	Save_Config(config)
	Check_And_Save_Window_Size()
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
	start_rebinding = true
	action_to_be_rebound = "Right"
# Up action rebind button
func _on_up_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_up_bind_button_button_down():
	Hover_SFX_Player.playing = true
	start_rebinding = true
	action_to_be_rebound = "Up"
# Down action rebind button
func _on_down_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_down_bind_button_button_down():
	Hover_SFX_Player.playing = true
	start_rebinding = true
	action_to_be_rebound = "Down"
# Jump action rebind button
func _on_jump_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_jump_bind_button_button_down():
	Hover_SFX_Player.playing = true
	start_rebinding = true
	action_to_be_rebound = "Jump"
# Glide action rebind button
func _on_glide_bind_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_glide_bind_button_button_down():
	Hover_SFX_Player.playing = true
	start_rebinding = true
	action_to_be_rebound = "Glide"
# Done button
func _on_controls_done_button_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_controls_done_button_button_down():
	Save_Config(config)
	Check_And_Save_Window_Size()
	Load_Options_Menu()

# This function is used for listening for the rebind key when a rebinding sequence is initiated
func _input(event):
	# Only rebind controls if the rebinding flag has been set to true
	if rebinding and event.is_action_type() and !event.is_echo():
		if event is InputEventMouseButton and event.is_pressed() == true:
			# Set secondary rebind slot icon to the primary slot's old image to make room for the new bind
			Rebind_Action_To_Secondary_Icon_Node_Dict.get(action_to_be_rebound).texture = Rebind_Action_To_Primary_Icon_Node_Dict.get(action_to_be_rebound).texture
			# Search for button icon in reference dict and apply it to the newly rebound slot. If not found, 
			# use blank mouse / key texture instead
			if Mouse_Index_To_Button_Icon_File_Name_Dict.has(event.button_index):
				Rebind_Action_To_Primary_Icon_Node_Dict.get(action_to_be_rebound).texture = Mouse_Index_To_Button_Icon_File_Name_Dict.get(event.button_index)
			else:
				Rebind_Action_To_Primary_Icon_Node_Dict.get(action_to_be_rebound).texture = load(blank_button_icon_folder_path+blank_key_texture_name)
			# Actually update the binds list in the config file
			Update_Config("Controls", action_to_be_rebound, Get_Config("Controls", action_to_be_rebound, 0), 1)
			Update_Config("Controls", action_to_be_rebound, "m"+str(event.button_index), 0)
			rebinding = false
		elif event is InputEventKey and event.is_pressed() == true:
			# Set secondary rebind slot icon to the primary slot's old image to make room for the new bind
			Rebind_Action_To_Secondary_Icon_Node_Dict.get(action_to_be_rebound).texture = Rebind_Action_To_Primary_Icon_Node_Dict.get(action_to_be_rebound).texture
			# Search for button icon in reference dict and apply it to the newly rebound slot. If not found, 
			# use blank mouse / key texture instead
			if Keycode_To_Button_Icon_File_Name_Dict.has(event.keycode):
				Rebind_Action_To_Primary_Icon_Node_Dict.get(action_to_be_rebound).texture = load(button_icon_folder_path+Keycode_To_Button_Icon_File_Name_Dict.get(event.keycode))
			else:
				Rebind_Action_To_Primary_Icon_Node_Dict.get(action_to_be_rebound).texture = load(blank_button_icon_folder_path+blank_mouse_texture_name)
			# Actually update the binds list in the config file
			Update_Config("Controls", action_to_be_rebound, Get_Config("Controls", action_to_be_rebound, 0), 1)
			Update_Config("Controls", action_to_be_rebound, "k"+str(event.keycode), 0)
			rebinding = false
		# Set the input as handled so it doesn't effect anything else in game
		get_viewport().set_input_as_handled()
		# Set the hsv value of the rebound icon's modulate back to 1 once rebinding is finished
		Rebind_Action_To_Secondary_Icon_Node_Dict.get(action_to_be_rebound).modulate.v = 1
		
	# Ignore the first input when rebinding button is pressed, enabling the next input to be the one bound,
	# otherwise the action will just be rebound to the button pressed to initiate the rebind as even though 
	# that action is handled already by the rebind button this is _input() and it receives all input anyways
	elif start_rebinding: 
		start_rebinding = false
		rebinding = true
		# Grey out action icon to show the rebinding process is active by setting hsv value to 0
		Rebind_Action_To_Secondary_Icon_Node_Dict.get(action_to_be_rebound).modulate.v = 0.5


# -------------------------------------------------Audio Menu Functions-----
# Master volume slider
func _on_master_volume_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_master_volume_slider_value_changed(value):
	Hover_SFX_Player.playing = true
	AudioServer.set_bus_volume_linear(0, value / 80)
func _on_master_volume_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Audio", "Master_Volume", Master_Volume_Slider.value)
# Music volume slider
func _on_music_volume_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_music_volume_slider_value_changed(value):
	Hover_SFX_Player.playing = true
	AudioServer.set_bus_volume_linear(1, value / 80)
func _on_music_volume_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Audio", "Music_Volume", Music_Volume_Slider.value)
# SFX volume slider
func _on_sfx_volume_slider_mouse_entered():
	Hover_SFX_Player.playing = true
func _on_sfx_volume_slider_value_changed(value):
	Hover_SFX_Player.playing = true
	AudioServer.set_bus_volume_linear(2, value / 80)
func _on_sfx_volume_slider_drag_ended(value_changed):
	if value_changed:
		Update_Config("Audio", "SFX_Volume", SFX_Volume_Slider.value)
# Done button
func _on_audio_done_button_mouse_entered() -> void:
	Hover_SFX_Player.playing = true
func _on_audio_done_button_button_down() -> void:
	Save_Config(config)
	Check_And_Save_Window_Size()
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
	Check_And_Save_Window_Size()
	Load_Options_Menu()

func Check_And_Save_Window_Size():
	Change_Override_Config("display/window/size/window_width_override", DisplayServer.window_get_size().x)
	Change_Override_Config("display/window/size/window_height_override", DisplayServer.window_get_size().y)


# -------------------------------------------------Other / Load Functions-----
func Start_Game():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

# Save settings upon quitting application at window manager request
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Save_Config(config)
		Check_And_Save_Window_Size()

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
	config.set_value("Audio", "Master_Volume", 70)
	config.set_value("Audio", "Music_Volume", 70)
	config.set_value("Audio", "SFX_Volume", 70)
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
	
	# Audio settings -- very important to divide each of these by around 100 to get a range close to 0-1
	# because otherwise upon loading an existing config file the player's eardrums will be blasted out by 
	# horribly deep-fried audio (ask me how I know)
	AudioServer.set_bus_volume_linear(0, config.get_value("Audio", "Master_Volume") / 80)
	Master_Volume_Slider.value = config.get_value("Audio", "Master_Volume")
	AudioServer.set_bus_volume_linear(1, config.get_value("Audio", "Music_Volume") / 80)
	Music_Volume_Slider.value = config.get_value("Audio", "Music_Volume")
	AudioServer.set_bus_volume_linear(2, config.get_value("Audio", "SFX_Volume") / 80)
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
