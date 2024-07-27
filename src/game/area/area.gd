class_name Area
extends Area2D

@export var type = "fire"


func _ready() -> void:
	body_entered.connect(_call_player.bind("_enter"))
	body_exited.connect(_call_player.bind("_exit"))

	for child in get_children():
		if child is ColorRect:
			child.z_index = -1

			var rect_shape = RectangleShape2D.new()
			rect_shape.size = Vector2(child.size)

			var col_shape = CollisionShape2D.new()
			col_shape.shape = rect_shape
			col_shape.position = child.position + child.size / 2

			add_child(col_shape)


func _call_player(body: Node2D, suffix: String) -> void:
	if body is Player:
		body.call(type + suffix)
