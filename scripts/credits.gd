extends Control

@onready var main_menu = $/root/Main/GUI/MainMenu

func _on_return_to_main_pressed() -> void:
	hide()
	main_menu.show()

