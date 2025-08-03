extends Control

@onready var main_menu = $/root/Main/GUI/MainMenu

var level_select_button_script: Script = preload("res://scripts/level_select_button.gd")

func _ready() -> void:
	# var pattern = RegEx.new()
	# var regex_pattern = r"^level(\d+)\.tscn$" # Pattern for level<N>.tscn
	
	# if pattern.compile(regex_pattern) == OK:
	var level_number = 1
	while ResourceLoader.exists("res://scenes/levels/level%d.tscn" % level_number):
		var level = "res://scenes/levels/level%d.tscn" % level_number
		var button = Button.new()
		button.text = str(level_number) # Set button text to the extracted digit
		button.name = level
		button.set_script(level_select_button_script)
		button.level_num = level_number
		button.disabled = level_number > $/root/Main.levels_unlocked
		$GridContainer.add_child(button)
		level_number += 1

	var viewport_size = get_viewport_rect().size
	$GridContainer.global_position.x = viewport_size.x / 2.0 - $GridContainer.columns * LevelSelectButton.BUTTON_SIZE / 2.0

func update_unlocked_levels() -> void:
	for button in $GridContainer.get_children():
		button.disabled = button.level_num > $/root/Main.levels_unlocked

func _on_return_to_main_pressed() -> void:
	main_menu.update_continue_button_enabled()
	main_menu.show()
	hide()
