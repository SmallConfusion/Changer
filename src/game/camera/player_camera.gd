class_name PlayerCamera
extends BasicCamera

@export var level_height := 2000.

@export var min_zoom := 1.0
@export var max_zoom := 0.4
@export var min_speed := 0.0
@export var max_speed := 20000.0
@export var zoom_curve := 1.0
@export var zoom_speed := 1.

@export var look_ahead_amount := 0.1
@export var move_speed := 1.

@export var min_x := 0.
@export var max_x := 15000.
@export var limit := 1500.
@export var edge_lock := 2500.

@export var player: Player


func _ready():
	if not player and get_parent() is Player:
		player = get_parent()
	elif not player:
		push_error("player not set and parent is not player")


func _process(delta: float) -> void:
	super(delta)

	var target_position := player.global_position

	target_position.y = (
		(floor(target_position.y / level_height) + 0.5) * level_height
	)

	if player.global_position.x < min_x + edge_lock:
		target_position.x = 0
	elif player.global_position.x > max_x - edge_lock:
		target_position.x = INF
	else:
		target_position.x += player.velocity.x * look_ahead_amount

	target_position.x = clamp(target_position.x, min_x + limit, max_x - limit)

	global_position = lerp(
		target_position, global_position, exp(-move_speed * delta)
	)

	var t := remap(player.get_speed(), min_speed, max_speed, 0, 1)
	t = clamp(t, 0, 1)

	var target_zoom: Vector2 = (
		Vector2(1, 1) * lerp(min_zoom, max_zoom, pow(t, zoom_curve))
	)

	zoom = lerp(target_zoom, zoom, exp(-zoom_speed * delta))
