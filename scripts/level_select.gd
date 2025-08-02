extends Control

@onready var main_menu = $/root/Main/GUI/MainMenu

var level_select_button_script: Script = preload("res://scripts/level_select_button.gd")

func _ready() -> void:
	var pattern = RegEx.new()
	var regex_pattern = r"^level(\d+)\.tscn$" # Pattern for level<N>.tscn
	
	if pattern.compile(regex_pattern) == OK:
		for level in DirAccess.get_files_at("res://scenes/levels"):
			var match = pattern.search(level)
			if match:
				var level_number = match.get_string(1) # Extract the digit
				var button = Button.new()
				button.text = level_number # Set button text to the extracted digit
				button.name = level
				button.set_script(level_select_button_script)
				button.level_num = int(level_number)
				$GridContainer.add_child(button)

	var viewport_size = get_viewport_rect().size
	$GridContainer.global_position.x = viewport_size.x / 2.0 - $GridContainer.columns * LevelSelectButton.BUTTON_SIZE / 2.0

func _on_return_to_main_pressed() -> void:
	main_menu.show()
	hide()
