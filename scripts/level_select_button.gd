extends Button

var level: PackedScene

func _ready() -> void:
	custom_minimum_size = Vector2(100, 100)
	add_theme_font_size_override("font_size", 64)
	level = load("res://scenes/levels/" + name.split('_')[0] + ".tscn")
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	$/root/Main.add_child(level.instantiate())
	$/root/Main/GUI/LevelSelect.hide()
