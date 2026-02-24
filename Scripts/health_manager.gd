extends Node2D

@export var max_health = 0
@export var I_frame_timer = 0

var current_health = 0
var taking_damage = false

func _ready() -> void:
	current_health = max_health
	
@warning_ignore("unused_parameter")
func Damage(value, ignore_i_frames = false):
	taking_damage = true
	current_health -= value
	get_tree().create_timer(I_frame_timer)
	taking_damage = false
	if CharacterBody2D and current_health > 0:
		get_parent().get_node("CanvasLayer/Cotrol/HealthBar").value -= value
		GameManager.healthforbar -= value
	if not CharacterBody2D and current_health <= 0:
		queue_free()
	if CharacterBody2D and current_health <= 0:
		GameManager.healthforbar = 20
		get_tree().reload_current_scene()
@warning_ignore("unused_parameter")
func Heal(value, ignore_max_health = false):
	current_health += value
