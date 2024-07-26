extends Camera2D


func _process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set(
		"camera_offset", global_position
	)
