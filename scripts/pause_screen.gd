extends ColorRect

func _on_return_to_game_pressed() -> void:
	get_tree().paused = false
	hide()
