extends Node2D

@onready var label = get_node("Area2D/Control/RichTextLabel")

@export var travel_sign = {0 : "res://Scenes/Areas/world.tscn"}
@export var sign_text = "World"

var is_in_area = false
var height_offset = 0 
var elapsed_time = 0
var text_bounce_frequency = 0.05
var text_bounce_amplitude = 10

func _ready() -> void:
	label.text = sign_text

func _process(delta: float) -> void:
	height_offset = sin(elapsed_time * text_bounce_frequency) * text_bounce_amplitude
	label.position.y += height_offset
	if Input.is_action_just_pressed("Up") and is_in_area:
		get_tree().change_scene_to_file(travel_sign.get(0))
	if is_in_area and $Area2D/Control/RichTextLabel.modulate.a < 100:
		$Area2D/Control/RichTextLabel.modulate.a += 3*delta
	elif not is_in_area and $Area2D/Control/RichTextLabel.modulate.a > 0:
		$Area2D/Control/RichTextLabel.modulate.a -= 3*delta
	elapsed_time += 1/60 * delta

#these two are for when the player enters the area and leaves, just stating the obvious.

func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_in_area = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	is_in_area = false
	
