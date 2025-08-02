extends Node2D

class_name Main

var current_level: int = 1

func load_level() -> void:
	# Clear the previous level
	var prev_level = get_node_or_null("Level")
	if prev_level:
		prev_level.name = "PrevLevel"
		prev_level.queue_free()

	var path = "res://scenes/levels/level%d.tscn" % current_level
	if ResourceLoader.exists(path):
		var level = load(path)
		add_child(level.instantiate())
	else:
		$GUI/WinScreen.show()
