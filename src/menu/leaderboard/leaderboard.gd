class_name Leaderboard
extends Panel

const leaderboard_id = "scorejampolymars-main-JXJb"
@onready var name_label: Label = $NameLabel
@onready var time_label: Label = $TimeLabel


func _ready() -> void:
	reload()


func _display_scores(scores):
	for score in scores:
		name_label.text += (
			"%d.\t%s\n" % [score.rank, score.name.replace(" ", "")]
		)
		time_label.text += "%10.3f s\n" % score.score


func reload() -> bool:
	name_label.text = ""
	time_label.text = ""

	var scores_res := await Leaderboards.get_scores(leaderboard_id, 0, 10)
	_display_scores(scores_res.scores)

	name_label.text += "...\n"
	time_label.text += "...\n"

	scores_res = await Leaderboards.get_nearby_scores(leaderboard_id, 5)
	_display_scores(scores_res.scores)

	return true
