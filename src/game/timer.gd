extends Label

@onready var game: Game = get_tree().get_first_node_in_group("game_manager")


func _ready() -> void:
	text = ""


func _process(delta: float) -> void:
	var time = game.get_current_time()
	var checkpoint = game.get_last_checkpoint_time()

	if checkpoint > 0:
		text = "Time:\t%.3f\nCheckpoint:\t%.3f" % [time, checkpoint]
	else:
		text = "Time:\t%.3f" % time
