class_name SceneLoadButton
extends Button

@export_file("*.tscn") var scene: String
@export var should_grab_focus := false


func _ready() -> void:
	pressed.connect(_on_press)

	if should_grab_focus:
		grab_focus()


func _on_press() -> void:
	get_tree().change_scene_to_file(scene)
