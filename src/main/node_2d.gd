extends Node2D

var leadarboard_name := "scorejampolymars-main-JXJb"


func _ready() -> void:
	var res = await Leaderboards.post_guest_score(
		leadarboard_name,
		1000.00115522255264654654,
		"test layer",
		{"deaths": 1004}
	)
	print(res)
