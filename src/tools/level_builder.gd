@tool
extends Node2D

@export var build := false:
	set(x):
		_build_level()

@export var size := 10000.
@export var level_height := 2000.
@export var floors := 10
@export var door_size := 2000.

@export var line_width := 10.

var height := level_height * floors


func _build_level() -> void:
	for child in get_children():
		child.queue_free()

	var extra := line_width / 2

	_add_line(-extra, 0, size + extra, 0)
	_add_line(-extra, -height, size + extra, -height)
	_add_line(0, extra, 0, -height - extra)
	_add_line(size, extra, size, -height - extra)

	for i in range(1, floors):
		var y = -i * level_height

		if i % 2 == 1:
			var end = size - door_size
			_add_line(0, y, end + extra, y)
			_add_one_way_line(end, y - extra, end, y + level_height + extra, 1)
		else:
			_add_line(door_size - extra, y, size, y)
			_add_one_way_line(
				door_size, y - extra, door_size, y + level_height + extra, -1
			)


func _add_line(x: float, y: float, x2: float, y2: float) -> void:
	var line = CollisionLine.new()

	line.add_point(Vector2(x, y))
	line.add_point(Vector2(x2, y2))

	add_child(line)
	line.owner = get_tree().edited_scene_root

	line.width = line_width


func _add_one_way_line(
	x: float, y: float, x2: float, y2: float, dir: float
) -> void:
	var line = OneWayCollisionLine.new()

	line.dir = dir

	line.add_point(Vector2(x, y))
	line.add_point(Vector2(x2, y2))

	add_child(line)
	line.owner = get_tree().edited_scene_root

	line.width = line_width
