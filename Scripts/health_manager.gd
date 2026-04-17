extends Node2D

@export var max_health = 1
@export var I_frame_timer = 1

var current_health = 1
var taking_damage = false


func _ready() -> void:
	current_health = max_health
	if get_parent().name == "Player":
		current_health = GameManager.TrueHealth 
@warning_ignore("unused_parameter")
func Damage(value): 
	taking_damage = true
	current_health -= value
	if get_parent().get_node("Damage_SFX_Player") != null:
		get_parent().get_node("Damage_SFX_Player").playing = true
	if get_tree() != null:
		get_tree().create_timer(I_frame_timer)
	taking_damage = false
	if get_parent().name == "Player":
		get_parent().get_parent().get_node("CanvasLayer").Damage(GameManager.TrueHealth - value)
		GameManager.TrueHealth -= value
		if current_health <= 0:
			GameManager.TrueHealth = 20
			get_tree().reload_current_scene()
			
	if not get_parent().name == "Player" and current_health <= 0:
		get_parent().queue_free()


@warning_ignore("unused_parameter")
func Heal(value):
	if (current_health + value)  <=max_health:
		current_health += value
		if get_parent().name == "Player":
			get_parent().get_parent().get_node("CanvasLayer").Damage(GameManager.TrueHealth + value)
			GameManager.TrueHealth += value
		if current_health > max_health:
			current_health = 20
