extends Button

var level: PackedScene

func _ready() -> void:
	custom_minimum_size = Vector2(100, 100)
	add_theme_font_size_override("font_size", 64)
	level = load("res://scenes/levels/" + name + ".tscn")
	connect("pressed", _on_pressed)

func _on_pressed() -> void:
	get_parent().get_parent().get_parent().add_child(level.instantiate())
	get_parent().get_parent().queue_free()
