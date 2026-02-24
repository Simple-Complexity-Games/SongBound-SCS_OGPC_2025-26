extends CanvasLayer

var low_text_height = -40.308
var high_text_height = -151.0


func _ready() -> void:
	$Control/HealthBar.value = GameManager.healthforbar
func set_healthbar():
	$Control/HealthBar.value = get_parent().get_node("Player/Health_Manager").current_health

func Show_Text(text):
	$Control/sign_text.text = text
	var text_visibility_tween = get_tree().create_tween()
	text_visibility_tween.tween_property($Control, "position:y", low_text_height, 0.75)

func Hide_Text():
	var text_visibility_tween = get_tree().create_tween()
	text_visibility_tween.tween_property($Control, "position:y", high_text_height, 0.75)
