extends Node2D

@onready var Animated_Sprite = get_node("Sprite2D")

func _ready() -> void:
	Animated_Sprite.play("Death")

func _on_sprite_2d_animation_finished() -> void:
	self.queue_free()
