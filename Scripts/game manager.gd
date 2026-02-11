extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func new_player_location():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
# make the sign script on ready to signal the game manager to teleport the player.
# make it where when the player enters the zone of the sign scripts it records the 
#name of the sign or a value you give it, from this when a new scene is loaded the sign would 
#signal the global scipt which would teleport the player to a sign in the new scene 
#with the same value as the sign in the previous scene.
