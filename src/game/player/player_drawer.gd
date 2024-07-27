extends Node2D

const RADIUS := 30
const BIRD_COLOR := Color(0, 0, 0)

var current_animal := Player.Animal.NONE

var DRAW_FUNCS := {
	Player.Animal.BIRD: _draw_bird,
	Player.Animal.FISH: _draw_fish,
	Player.Animal.PHOENIX: _draw_phoenix
}

const COLORS := {
	Player.Animal.BIRD: Color(0, 0, 0),
	Player.Animal.FISH: Color(0, 0, 1),
	Player.Animal.PHOENIX: Color(1, 0, 0)
}


func _draw() -> void:
	DRAW_FUNCS[current_animal].call()


func _draw_bird() -> void:
	draw_arc(
		Vector2.ZERO, 30, 0, PI, 32, BIRD_COLOR, Visuals.MARKER_WIDTH, true
	)

	draw_line(
		Vector2(-RADIUS - Visuals.MARKER_WIDTH / 2, -Visuals.MARKER_WIDTH / 2),
		Vector2(RADIUS + Visuals.MARKER_WIDTH / 2, -Visuals.MARKER_WIDTH / 2),
		COLORS[Player.Animal.BIRD],
		Visuals.MARKER_WIDTH,
		true
	)


func _draw_fish() -> void:
	draw_arc(
		Vector2.ZERO,
		RADIUS,
		-PI * 0.6,
		PI * 0.6,
		32,
		COLORS[Player.Animal.FISH],
		Visuals.MARKER_WIDTH,
		true
	)

	draw_polyline(
		PackedVector2Array(
			[
				Vector2(-7, RADIUS),
				Vector2(-3 * RADIUS, -0.9 * RADIUS),
				Vector2(-3 * RADIUS, 0.9 * RADIUS),
				Vector2(-7, -RADIUS)
			]
		),
		COLORS[Player.Animal.FISH],
		Visuals.MARKER_WIDTH,
		true
	)


func _draw_phoenix() -> void:
	draw_circle(
		Vector2.ZERO,
		RADIUS,
		COLORS[Player.Animal.PHOENIX],
		false,
		Visuals.MARKER_WIDTH,
		true
	)


func set_animal(animal: Player.Animal) -> void:
	if current_animal != animal:
		current_animal = animal
		queue_redraw()
