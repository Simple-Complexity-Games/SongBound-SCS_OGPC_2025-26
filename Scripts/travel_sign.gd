extends Node2D

@onready var label = get_node("CanvasLayer/Control/RichTextLabel")

@export var travel_sign = {0 : "res://Scenes/Areas/world.tscn"}
@export var sign_text = "World"

var is_in_area = false

func _ready() -> void:
	label.text = sign_text

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Up") and is_in_area:
		get_tree().change_scene_to_file(travel_sign.get(0))
	if is_in_area and $CanvasLayer/Control/RichTextLabel.modulate.a < 100:
		$CanvasLayer/Control/RichTextLabel.modulate.a += 3*delta
	elif not is_in_area and $CanvasLayer/Control/RichTextLabel.modulate.a > 0:
		$CanvasLayer/Control/RichTextLabel.modulate.a -= 3*delta
#these two are for when the player enters the area and leaves, just stating the obvious.

func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_in_area = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	is_in_area = false
	
