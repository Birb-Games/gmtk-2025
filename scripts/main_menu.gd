extends Control

func _on_select_level_pressed() -> void:
	get_parent().add_child(preload("res://scenes/level_select.tscn").instantiate())
	queue_free()

func _on_credits_pressed() -> void:
	get_parent().add_child(preload("res://scenes/credits.tscn").instantiate())
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()
