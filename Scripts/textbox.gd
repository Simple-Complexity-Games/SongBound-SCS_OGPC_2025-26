extends RichTextLabel

@onready var character_icon = get_parent().get_node("Character_Icon")
@onready var audio_player = get_parent().get_parent().get_node("Audio_Player")
@onready var test_textbox = get_node("Test_Textbox")

var icon_ids_to_paths = {"char1_neutral":0, "char1_happy":1}

var timer : Timer = Timer.new()

@export var default_text_speed = 280.0

var index = 0
var text_stack = ""
var tags = {}

var skip_requested = false

signal done_printing


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for node in get_tree().get_nodes_in_group("Dialog_Triggers"):
		#print(node)
		#self.done_printing.connect(node.done_printing().bind())
	
	add_child(timer)
	timer.one_shot = true

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Up")) and index > 0:
		print("queued skip")
		skip_requested = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if index < text_stack.length() and timer.time_left == 0:
		audio_player.playing = true
		Print_Text(text_stack[index])
		timer.wait_time = (1 / (default_text_speed))
		
		if not tags.has(index):
			pass
		elif "pause" in tags[index]:
			timer.wait_time = (60 / (default_text_speed))
		
		timer.start()
		index += 1
	elif index >= text_stack.length():
		done_printing.emit()
		#print("done printing")
	elif skip_requested:
		print("SKIP")
		skip_requested = false
		
		timer.stop()
		var stopping_point = text_stack.length() + 1
		
		self.append_text(text_stack.substr(index, stopping_point + 1))
		index = stopping_point

func Play_Line(line):
	#var data = ["", ""]
	#var section = 0
	#for char in line:
		#if char == ":" and section == 0:
			#section += 1
		#else:
			#data[section] += char
	
	if index < text_stack.length():
		print("skipped")
		skip_requested = true
	else:
		print("playing line")
		var data = line
		data = Get_Text_Tags(data)
		data = Add_Newlines(data)
		
		#Update_Icon(data[0])
		self.clear()
		text_stack = data
		index = 0
		skip_requested = false

func Update_Icon(icon_id):
	character_icon.frame = icon_ids_to_paths[String(icon_id)]

func Print_Text(text):
	self.append_text(text)

# Iterate through the given text and find any places where the text will wrap around and insert a newline 
# there so when printing the text it doesn't start printing on one line then wrap in the middle. 
# This code is inspired by (copied from) a comment on this post:
# https://forum.godotengine.org/t/detect-when-text-wraps-to-add-custom-behaviour/41515/3
func Add_Newlines(text):
	test_textbox.clear()
	
	var current_line_count = test_textbox.get_line_count()
	
	var loaded_text = 0
	for i in text.length():
		if current_line_count < test_textbox.get_line_count():
			var current_text = text.substr(0, loaded_text)
			
			var word_start_offset = current_text.reverse().find(" ")
			
			var newline_index = (loaded_text - word_start_offset - 1)
			
			text = text.erase(newline_index)
			text = text.insert(newline_index, "\n")
			
			current_line_count = test_textbox.get_line_count()
			loaded_text += 1
		
		loaded_text += 1
		test_textbox.append_text(text[i])
	
	return text

func Get_Text_Tags(text):
	tags.clear()
	
	var char_tags = ""
	
	index = 0
	for char in text:
		if index == text.length():
			break
		elif char == "*":
			text = text.erase(index)
			index -= 1
			char_tags += "pause;"
		#elif char == "|":
			#text = text.erase(index)
			#index -= 1
			#char_tags += "skip_stop;"
		
		if char_tags != "":
			if tags.has(index):
				char_tags += tags[index]
			tags[index] = char_tags
			char_tags = ""
		
		index += 1
	return text
