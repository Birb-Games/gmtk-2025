extends Button

class_name LevelSelectButton

var level_num: int = 0

const BUTTON_SIZE = 120

func _ready() -> void:
	custom_minimum_size = Vector2(BUTTON_SIZE, BUTTON_SIZE)
	add_theme_font_size_override("font_size", 80)
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	var main: Main = $/root/Main
	main.current_level = level_num
	main.load_level()
	$/root/Main/GUI/LevelSelect.hide()
