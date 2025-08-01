extends Control

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
				$GridContainer.add_child(button)

func _on_return_to_main_pressed() -> void:
	get_parent().add_child(preload("res://scenes/main_menu.tscn").instantiate())
	queue_free()
