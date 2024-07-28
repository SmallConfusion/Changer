extends CanvasGroup

@export var play_in_editor := true


func _ready() -> void:
	if not play_in_editor and OS.has_feature("Engine"):
		visible = false
	else:
		await get_tree().create_timer(3).timeout

		var tween = get_tree().create_tween()

		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_SINE)

		await (
			tween
			. tween_property(self, "self_modulate", Color(1, 1, 1, 0), 1)
			. finished
		)

		print("done")

		visible = false
