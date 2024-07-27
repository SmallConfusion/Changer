class_name OneWayCollisionLine
extends CollisionLine

## Ignores collision if this direction == player direction
@export var dir := 1


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var player: Player = get_tree().get_first_node_in_group("player")
	var player_dir := player.get_direction()

	if player_dir == dir:
		static_body.collision_layer = 0
	else:
		static_body.collision_layer = 1
