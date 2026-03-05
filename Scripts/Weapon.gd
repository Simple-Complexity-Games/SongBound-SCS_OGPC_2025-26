extends Node2D


# Called when the node enters the scene tree for the first time.


func Attack():
	if Input.is_action_pressed("Attack"):
		
		if Input.is_action_pressed("Right"):
			$attack_box.position.x = 67.5
			$attack_box/CollisionShape2D.disabled = false
			get_tree().create_timer(1)
			$attack_box/CollisionShape2D.disabled = true
# 80 pixels form player for the middle hit boxes right side to the players right side. each box is 24 wide, 8 tall.
#think of its middle of 12 when possitioning as in minus it by 12 dumbass
