extends Control

var level_directory: EditorFileSystemDirectory = EditorFileSystemDirectory.new()
var level_select_button_script: Script = preload("res://scripts/level_select_button.gd")

func _ready() -> void:
	level_directory.open("res://scenes/levels")
	for i in level_directory.get_file_count():
		var level = level_directory.get_file(i)
		var button = Button.new()
		button.text = i + 1
		button.name = level
		button.set_script(level_select_button_script)
		$GridContainer.add_child(button)
