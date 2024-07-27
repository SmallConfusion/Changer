class_name Game
extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

var current_checkpoint: CheckpointCollisionLine


func _ready() -> void:
	for child in $LevelBuilder.get_children():
		if child is CheckpointCollisionLine:
			child.checkpoint_reached.connect(_checkpoint_reached.bind(child))

	player.die.connect(_player_die)


func _checkpoint_reached(checkpoint: CheckpointCollisionLine) -> void:
	if current_checkpoint == checkpoint:
		return

	current_checkpoint = checkpoint


func _player_die() -> void:
	if current_checkpoint:
		player.position = current_checkpoint.get_checkpoint_position()
		player.dir = current_checkpoint.dir
	else:
		player.position = Vector2(1000, -1000)
		player.dir = 1
