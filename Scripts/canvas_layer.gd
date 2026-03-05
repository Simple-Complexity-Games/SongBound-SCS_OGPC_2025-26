extends CanvasLayer

var low_text_height = -40.308
var high_text_height = -151.0
var feather_bits = 20
var dammage_time = 1.25

func _ready() -> void:
	feather_bits = GameManager.TrueHealth

func _process(_delta: float) -> void:
	$FeatherAnimation.frame = floor(feather_bits)

func Damage(new_health) -> void:
	var health_tween = get_tree().create_tween()
	health_tween.set_ease(Tween.EASE_OUT)
	health_tween.set_trans(Tween.TRANS_EXPO)
	health_tween.tween_property(self, "feather_bits", new_health, dammage_time)

func Show_Text(text):
	$Control/sign_text.text = text
	var text_visibility_tween = get_tree().create_tween()
	text_visibility_tween.tween_property($Control, "position:y", low_text_height, 0.75)

func Hide_Text():
	var text_visibility_tween = get_tree().create_tween()
	text_visibility_tween.tween_property($Control, "position:y", high_text_height, 0.75)
