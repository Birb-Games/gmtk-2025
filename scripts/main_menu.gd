extends Control

@onready var credits = $/root/Main/GUI/Credits
@onready var level_select = $/root/Main/GUI/LevelSelect

func _on_select_level_pressed() -> void:
	hide()
	level_select.show()

func _on_credits_pressed() -> void:
	hide()
	credits.show()

func _on_quit_pressed() -> void:
	get_tree().quit()
