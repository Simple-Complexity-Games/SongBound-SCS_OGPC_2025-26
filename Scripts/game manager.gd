extends Node

var sign_location = "Sparrow Sanctuary"
var pos_x = 43
var pos_y = 29
var healthforbar = 20
	

	
# make the sign script on ready to signal the game manager to teleport the player.
# make it where when the player enters the zone of the sign scripts it records the 
#name of the sign or a value you give it, from this when a new scene is loaded the sign would 
#signal the global scipt which would teleport the player to a sign in the new scene 
#with the same value as the sign in the previous scene.
