extends RichTextLabel

@onready var character_icon = get_parent().get_node("Character_Icon")
@onready var audio_player = get_parent().get_parent().get_node("Audio_Player")
@onready var test_textbox = get_node("Test_Textbox")

var icon_ids_to_paths = {"char1_neutral":0, "char1_happy":1}

var timer : Timer = Timer.new()

@export var default_text_speed = 280.0

var char_index = 0
var text_stack = ""
var tags = {}

var skip_requested = false
var waiting = true

signal done_printing


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for node in get_tree().get_nodes_in_group("Dialog_Triggers"):
		#print(node)
		#self.done_printing.connect(node.done_printing().bind())
	
	add_child(timer)
	timer.one_shot = true

func _input(event: InputEvent) -> void:
	pass
	#if (Input.is_action_just_pressed("Up")) and char_index > 0:
		#print("queued skip")
		#skip_requested = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if char_index < text_stack.length() and timer.time_left == 0:
		audio_player.playing = true
		Print_Text(text_stack[char_index])
		timer.wait_time = (1 / (default_text_speed))
		
		if not tags.has(char_index):
			pass
		elif "pause" in tags[char_index]:
			timer.wait_time = (60 / (default_text_speed))
		
		timer.start()
		char_index += 1
	elif char_index >= text_stack.length() and text_stack.length() > 0:
		#print("dooonee")
		done_printing.emit()
		#print("done printing")
	elif skip_requested:
		#print("SKIP")
		skip_requested = false
		
		timer.stop()
		var stopping_point = text_stack.length() + 1
		
		self.append_text(text_stack.substr(char_index, stopping_point + 1))
		char_index = stopping_point

func Play_Line(line):
	#var data = ["", ""]
	#var section = 0
	#for char in line:
		#if char == ":" and section == 0:
			#section += 1
		#else:
			#data[section] += char
	
	#if index < text_stack.length():
		#print("skipped")
		#skip_requested = true
	if char_index >= text_stack.length() or char_index == 0:
		#print("playing line")
		var data = line
		data = Add_Newlines(data)
		data = Get_Text_Tags(data)
		
		#Update_Icon(data[0])
		self.clear()
		text_stack = data
		char_index = 0
		skip_requested = false
	#print("text_stack",text_stack)

func Update_Icon(icon_id):
	character_icon.frame = icon_ids_to_paths[String(icon_id)]

func Print_Text(text):
	self.append_text(text)

# Iterate through the given text and find any places where the text will wrap around and insert a newline 
# there so when printing the text it doesn't start printing on one line then wrap in the middle. 
# This code was originally inspired by a comment on this post:
# https://forum.godotengine.org/t/detect-when-text-wraps-to-add-custom-behaviour/41515/3
func Add_Newlines(text):
	test_textbox.clear()
	
	var current_line_count = test_textbox.get_line_count()
	#print("current count: ",current_line_count)
	var loaded_text = 0
	for i in text.length():
		var current_text = text.substr(0, loaded_text)
		if test_textbox.get_line_count() > current_line_count:
			var word_start_offset = 2
			#print("text[i - 1]: ",text[i - 1])
			#print("text[i]: ",text[i])
			#print("text[i + 1]: ",text[i + 1])
			if text[i - 2] != " ":
				#print("start_offset")
				word_start_offset = current_text.reverse().find(" ")
			
			var newline_index = (loaded_text - word_start_offset)
			
			#print("/n? ",current_text.substr(newline_index, loaded_text).find("\n"))
			if current_text.substr(newline_index, loaded_text).find("\n") == -1:
				#print("inserting at: ",text[newline_index])
				text = text.insert(newline_index, "\n")
				if text[newline_index + 1] == " ":
					text = text.erase(newline_index + 1)
			
			current_line_count = test_textbox.get_line_count()
		
		#print("prev_text: ",text.substr(max(0, loaded_text - 60), loaded_text))
		#print("new_text: ",text.substr(0, loaded_text))
		#print("new count: ",test_textbox.get_line_count())
		test_textbox.append_text(text[i])
		loaded_text += 1
	
	#print("processed_text:", text)
	return text

func Get_Text_Tags(text):
	tags.clear()
	
	var char_tags = ""
	
	var index = 0
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
