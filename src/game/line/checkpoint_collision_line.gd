class_name CheckpointCollisionLine
extends CollisionLine

const checkpoint_offset := 200.

## Ignores collision if this direction == player direction
@export var dir := 1
@export var end := false


func _ready() -> void:
	super()

	var area := Area2D.new()

	var static_body_shape: CollisionShape2D = static_body.get_child(0)

	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()

	shape.shape.size = static_body_shape.shape.size * Vector2(1, 10)
	shape.position = static_body_shape.position
	shape.rotation = static_body_shape.rotation

	area.add_child(shape)

	area.body_entered.connect(_body_entered)

	add_child(area)


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var player: Player = get_tree().get_first_node_in_group("player")
	var player_dir := player.get_direction()

	if player_dir == dir:
		static_body.collision_layer = 0
	else:
		static_body.collision_layer = 1


func get_checkpoint_position() -> Vector2:
	var middle: Vector2 = lerp(
		get_point_position(0), get_point_position(1), 0.5
	)

	return middle + checkpoint_offset * Vector2(dir, 0)
