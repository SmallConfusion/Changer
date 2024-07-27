class_name Leaderboard
extends Panel

const leaderboard_id = "scorejampolymars-main-JXJb"
@onready var name_label: Label = $ScrollContainer/MarginContainer/NameLabel
@onready var time_label: Label = $ScrollContainer/MarginContainer/TimeLabel


func _ready() -> void:
	var scores_res := await Leaderboards.get_scores(leaderboard_id, 0, 50)

	_display_scores(scores_res.scores)


func _display_scores(scores):
	name_label.text = ""
	time_label.text = ""

	var i := 0
	for score in scores:
		i += 1

		name_label.text += "%d.\t%s\n" % [i, score.name.replace(" ", "")]
		time_label.text += "%10.3f\n" % score.score


func _generate_testing_scores(count: int) -> Array:
	randomize()

	var scores := []

	for i in range(count):
		var score = {"name": "%d" % randi(), "score": randf() * 100.}
		scores.append(score)

	return scores
