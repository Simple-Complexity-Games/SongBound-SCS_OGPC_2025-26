extends Node2D

@export var max_health = 0
@export var I_frame_timer = 0

var current_health = 0
var taking_damage = false

func _ready() -> void:
	current_health = max_health
	
func Damage(value, ignore_i_frames = false):
	taking_damage = true
	current_health -= value
	get_tree().create_timer(I_frame_timer)
	taking_damage = false
	if current_health <= 0:
		queue_free()

func Heal(value, ignore_max_health = false):
	current_health += value
