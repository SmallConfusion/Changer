class_name PlayerCamera
extends BasicCamera

const LEVEL_HEIGHT := 2000.

@export var follow: Player


func _ready():
	if not follow and get_parent() is Player:
		follow = get_parent()
	elif not follow:
		push_error("Follow not set and parent is not player")


func _process(delta: float) -> void:
	super(delta)

	global_position = follow.global_position
	global_position.y = (
		(floor(global_position.y / LEVEL_HEIGHT) + 0.5) * LEVEL_HEIGHT
	)
