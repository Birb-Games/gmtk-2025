extends Control

func _on_credits_pressed() -> void:
	hide()
	$/root/Main/GUI/Credits.show()
	# Reset to the beginning
	$/root/Main.current_level = 1
