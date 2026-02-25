extends Node2D

@export var max_health = 1
@export var I_frame_timer = 0

var current_health = 1
var taking_damage = false

func _ready() -> void:
	current_health = max_health

@warning_ignore("unused_parameter")
func Damage(value, ignore_i_frames = false):
	taking_damage = true
	current_health -= value
	get_tree().create_timer(I_frame_timer)
	taking_damage = false
	if CharacterBody2D:
		GameManager.healthforbar -= value
		if current_health <= 0:
			GameManager.healthforbar = 20
			get_tree().reload_current_scene()
			
	if not CharacterBody2D and current_health <= 0:
		queue_free()

@warning_ignore("unused_parameter")
func Heal(value, ignore_max_health = false):
	current_health += value
