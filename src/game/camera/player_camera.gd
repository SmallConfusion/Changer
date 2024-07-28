class_name PlayerCamera
extends BasicCamera

@export var level_height := 2000.

@export var min_zoom := 1.0
@export var max_zoom := 0.4
@export var min_speed := 0.0
@export var max_speed := 20000.0
@export var zoom_curve := 1.0
@export var zoom_speed := 1.0

@export var look_ahead_amount := 0.1
@export var look_ahead_constant := 300.0
@export var move_speed := 1.0

@export var min_x := 0.0
@export var max_x := 15000.0
@export var limit := 1500.0
@export var edge_lock := 2500.0

@export var player: Player


func _ready():
	if not player and get_parent() is Player:
		player = get_parent()
	elif not player:
		push_error("player not set and parent is not player")

	global_position = _get_target_position()
	zoom = _get_target_zoom()


func _process(delta: float) -> void:
	global_position = lerp(
		_get_target_position(), global_position, exp(-move_speed * delta)
	)

	zoom = lerp(_get_target_zoom(), zoom, exp(-zoom_speed * delta))

	global_position.x = clamp(
		global_position.x,
		player.global_position.x - 1920 / zoom.x,
		player.global_position.x + 1920 / zoom.x
	)
	
	super(delta)

func _get_target_zoom() -> Vector2:
	var t := remap(player.get_speed(), min_speed, max_speed, 0, 1)
	t = clamp(t, 0, 1)

	var target_zoom: Vector2 = (
		Vector2(1, 1) * lerp(min_zoom, max_zoom, pow(t, zoom_curve))
	)

	return target_zoom


func _get_target_position() -> Vector2:
	var target_position := player.global_position

	target_position.y = (
		(floor(target_position.y / level_height) + 0.5) * level_height
	)

	if player.global_position.x < min_x + edge_lock:
		target_position.x = 0
	elif player.global_position.x > max_x - edge_lock:
		target_position.x = INF
	else:
		target_position.x += (
			(player.velocity.x + sign(player.velocity.x) * look_ahead_constant)
			* look_ahead_amount
		)

	target_position.x = clamp(target_position.x, min_x + limit, max_x - limit)

	return target_position
