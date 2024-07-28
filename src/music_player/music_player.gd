extends AudioStreamPlayer

@export var play_in_editor := false


func _ready() -> void:
	if OS.has_feature("editor") and not play_in_editor:
		playing = false

	get_tree().create_tween().tween_property(self, "volume_db", 0, 0.2)
