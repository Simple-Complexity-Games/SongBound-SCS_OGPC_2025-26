extends Node2D

@export var max_health = 0
var current_health = 0

func _ready() -> void:
	current_health = max_health
	
