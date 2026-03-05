extends Node2D

@export var max_health = 1
@export var I_frame_timer = .1

var current_health = 1
var taking_damage = false

func _ready() -> void:
	if not CharacterBody2D:
		current_health = max_health
	if CharacterBody2D:
		current_health = GameManager.TrueHealth 
@warning_ignore("unused_parameter")
func Damage(value, ignore_i_frames = false):
	taking_damage = true
	current_health -= value
	get_tree().create_timer(I_frame_timer)
	taking_damage = false
	if CharacterBody2D:
		get_parent().get_parent().get_node("CanvasLayer").Damage(GameManager.TrueHealth - value)
		GameManager.TrueHealth -= value
		if current_health <= 0:
			GameManager.TrueHealth = 20
			get_tree().reload_current_scene()
			
	if not CharacterBody2D and current_health <= 0:
		queue_free()

@warning_ignore("unused_parameter")
func Heal(value, ignore_max_health = false):
	current_health += value
	if CharacterBody2D:
		GameManager.TrueHealth += value
