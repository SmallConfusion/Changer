extends Node2D


func _draw():
	draw_circle(
		Vector2.ZERO, 20, Visuals.PENCIL_COLOR, false, Visuals.LINE_WIDTH, true
	)
