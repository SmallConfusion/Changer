extends Node2D

const colors := {
	Player.Animal.BIRD: Color(0, 0, 0),
	Player.Animal.FISH: Color(0, 0, 1),
	Player.Animal.PHOENIX: Color(1, 0.2, 0.2),
	Player.Animal.NONE: Color(0.5, 0.5, 0.5),
}

var current_animal := Player.Animal.NONE


func set_animal(animal: Player.Animal) -> void:
	if current_animal != animal:
		current_animal = animal
		queue_redraw()


func _draw():
	draw_circle(
		Vector2.ZERO,
		20,
		Visuals.PENCIL_COLOR,
		false,
		Visuals.MARKER_WIDTH,
		true
	)
