extends Control

@onready var credits = $/root/Main/GUI/Credits
@onready var level_select = $/root/Main/GUI/LevelSelect

var master = AudioServer.get_bus_index("Master")

func _ready() -> void:
	# Hide the quit button on web
	if OS.get_name() == "Web":
		$VBoxContainer/Quit.hide()
	var volume = AudioServer.get_bus_volume_db(master)
	$VolumeSlider.value = db_to_linear(volume) * 100.0

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

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master, linear_to_db(value / 100.0))
