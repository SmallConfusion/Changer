extends RichTextLabel


func _ready() -> void:
	meta_clicked.connect(_meta_clicked)


func _meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
