extends Node2D

@export var max_health = 0

var current_health = 0

var taking_damage = false

func _ready() -> void:
	current_health = max_health
	
func Damage(value, ignore_i_frames = false):
	taking_damage = true
	current_health -= value
	
func Heal(value, ignore_max_health = false):
	current_health += value
