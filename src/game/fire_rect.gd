extends ColorRect

const level_height := 2000.
const move_speed := .25

@onready var player: Player = get_tree().get_first_node_in_group("player")
var initial_position: Vector2


func _ready() -> void:
	initial_position = position + Vector2(0, level_height)
	position = initial_position


func _process(delta: float) -> void:
	var target_position := initial_position
	target_position.y += floor(player.position.y / level_height) * level_height

	position = lerp(target_position, position, exp(-move_speed * delta))
