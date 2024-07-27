class_name CollisionLine
extends Line

signal checkpoint_reached

var static_body: StaticBody2D


func _ready() -> void:
	super()

	static_body = StaticBody2D.new()

	var p1 = get_point_position(0)
	var p2 = get_point_position(1)

	var collision_shape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()

	shape.size = Vector2((p2 - p1).length(), Visuals.PENCIL_WIDTH)

	collision_shape.shape = shape
	collision_shape.position = (p2 - p1) / 2 + p1
	collision_shape.rotation = Vector2(p2 - p1).angle()

	static_body.add_child(collision_shape)

	add_child(static_body)


func _body_entered(body: Node2D) -> void:
	if body is Player:
		checkpoint_reached.emit()
