class_name Game
extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

var current_checkpoint: CheckpointCollisionLine


func _ready() -> void:
	for child in $LevelBuilder.get_children():
		if child is CheckpointCollisionLine:
			child.checkpoint_reached.connect(_checkpoint_reached.bind(child))


func _checkpoint_reached(checkpoint: CheckpointCollisionLine) -> void:
	if current_checkpoint == checkpoint:
		return

	current_checkpoint = checkpoint
	player.position = checkpoint.get_checkpoint_position()
