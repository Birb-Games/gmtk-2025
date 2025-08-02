extends Node2D

class_name Main

var current_level: int = 1

var save: ConfigFile = ConfigFile.new()
var levels_unlocked = 1
var has_watched_cutscene: bool = false

func _ready() -> void:
	if save.load("user://save.cfg") == OK:
		levels_unlocked = save.get_value("", "levels_unlocked", 1)
		current_level = save.get_value("", "current_level", 1)
		has_watched_cutscene = save.get_value("", "has_watched_cutscene", false)
	
	if has_watched_cutscene:
		$GUI/StartingCutScene._on_skip_pressed()
	$GUI/MainMenu.update_continue_button_enabled()

func unlock_next_level() -> void:
	levels_unlocked += 1
	save.set_value("", "levels_unlocked", levels_unlocked)
	save.save("user://save.cfg")

func update_current_level(next_level: bool = false) -> void:
	if next_level:
		current_level += 1
	save.set_value("", "current_level", current_level)
	save.save("user://save.cfg")

func reset_save() -> void:
	levels_unlocked = 1
	current_level = 1
	save.set_value("", "levels_unlocked", levels_unlocked)
	save.set_value("", "current_level", current_level)
	save.set_value("", "has_watched_cutscene", false)
	save.save("user://save.cfg")
	$/root/Main/GUI/MainMenu.update_continue_button_enabled()

func mark_cutscene_watched() -> void:
	has_watched_cutscene = true
	save.set_value("", "has_watched_cutscene", has_watched_cutscene)
	save.save("user://save.cfg")

func load_level() -> void:
	# Clear the previous level
	var prev_level = get_node_or_null("Level")
	if prev_level:
		prev_level.name = "PrevLevel"
		prev_level.queue_free()

	var path = "res://scenes/levels/level%d.tscn" % current_level
	if ResourceLoader.exists(path):
		var level = load(path)
		add_child(level.instantiate())
	else:
		$GUI/WinScreen.show()

	update_current_level()
