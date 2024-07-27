class_name Area
extends Area2D

@export var type = "fire"


func _ready() -> void:
	body_entered.connect(_call_player.bind("_entered"))
	body_exited.connect(_call_player.bind("_exited"))


func _call_player(body: Node2D, suffix: String) -> void:
	if body is Player:
		body.call(type + suffix)
