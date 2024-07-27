extends AudioStreamPlayer

@export var play_in_editor := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("editor") and not play_in_editor:
		playing = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
