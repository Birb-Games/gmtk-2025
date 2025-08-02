extends Control

@onready var credits = $/root/Main/GUI/Credits
@onready var level_select = $/root/Main/GUI/LevelSelect

func _ready() -> void:
	# Hide the quit button on web
	if OS.get_name() == "HTML5":
		$VBoxContainer/Quit.hide()

func update_continue_button_enabled() -> void:
	if $/root/Main.levels_unlocked == 1:
		$VBoxContainer/Continue.text = "Start"
	else:
		$VBoxContainer/Continue.text = "Continue"

func _on_select_level_pressed() -> void:
	hide()
	level_select.update_unlocked_levels()
	level_select.show()

func _on_credits_pressed() -> void:
	hide()
	credits.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_continue_pressed() -> void:
	$/root/Main.load_level()
	$/root/Main/GUI/MainMenu.hide()

func _on_reset_save_pressed() -> void:
	hide()
	$/root/Main/GUI/ConfirmWipeSave.show()
