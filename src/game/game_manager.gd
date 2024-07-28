class_name Game
extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")

var current_checkpoint: CheckpointCollisionLine
var last_checkpoint_time := -1.0

var start_time := 0.0


func _ready() -> void:
	for child in $LevelBuilder.get_children():
		if child is CheckpointCollisionLine:
			child.checkpoint_reached.connect(_checkpoint_reached.bind(child))

	player.die.connect(_player_die)

	start_time = Time.get_ticks_msec()


func _process(_delta: float) -> void:
	var diff: float = $FireRect.position.y - $PlayerCamera.position.y
	var volume: float = clamp(remap(diff, 700, 3000, -5, -20), -20, -5)
	$FirePlayer.volume_db = volume


func _input(e: InputEvent) -> void:
	if e.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _checkpoint_reached(checkpoint: CheckpointCollisionLine) -> void:
	if current_checkpoint == checkpoint:
		return

	GlobalSounds.play("Checkpoint")
	last_checkpoint_time = Time.get_ticks_msec() - start_time
	current_checkpoint = checkpoint

	if checkpoint.end:
		_end_game()


func _end_game():
	LeaderboardGlobal.time = get_current_time()

	(
		get_tree()
		. change_scene_to_file
		. bind("res://menu/leaderboard/leaderboard_screen.tscn")
		. call_deferred()
	)


func _player_die() -> void:
	if current_checkpoint:
		player.position = current_checkpoint.get_checkpoint_position()
		player.dir = -current_checkpoint.dir
	else:
		player.position = Vector2(1000, -1000)
		player.dir = 1

	player.velocity = Vector2.ZERO
	player.current_animal = Player.Animal.BIRD
	player.previous_animal = Player.Animal.BIRD


func get_current_time() -> float:
	return (Time.get_ticks_msec() - start_time) / 1000.


func get_last_checkpoint_time() -> float:
	return last_checkpoint_time / 1000.
