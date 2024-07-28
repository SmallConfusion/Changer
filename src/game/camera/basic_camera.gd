class_name BasicCamera
extends Camera2D


func _process(_delta: float) -> void:
	RenderingServer.global_shader_parameter_set(
		"camera_offset", global_position
	)
	
	RenderingServer.global_shader_parameter_set(
		"camera_zoom", zoom.x
	)
