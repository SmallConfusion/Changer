extends CanvasGroup

@export var play_in_editor := true


func _ready() -> void:
	if (
		(OS.has_feature("editor") and not play_in_editor)
		or not LeaderboardGlobal.first_boot
	):
		visible = false
	else:
		LeaderboardGlobal.first_boot = false
		visible = true
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
