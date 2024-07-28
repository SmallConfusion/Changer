extends VBoxContainer

@onready var line_edit: LineEdit = $LineEdit
@onready var leaderboard: Leaderboard = $"../Panel"


func _ready() -> void:
	if LeaderboardGlobal.time == -1:
		visible = false
		return

	$TimeLabel.text += "%10.3f seconds." % LeaderboardGlobal.time

	$SubmitButton.pressed.connect(_submit_time)


func _submit_time() -> void:
	var text = line_edit.text

	if text and LeaderboardGlobal.time > 0:
		await Leaderboards.post_guest_score(
			"scorejampolymars-main-JXJb", LeaderboardGlobal.time, text
		)

		await leaderboard.reload()

		$SuccessLabel.visible = true
		LeaderboardGlobal.time = -1
