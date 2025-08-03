extends AudioStreamPlayer

var has_been_in_level: bool = false

func _process(delta: float) -> void:
	if $/root/Main/GUI/StartingCutScene.is_visible() and !playing:
		play()
	if $/root/Main/Level != null and !playing:
		play()
		has_been_in_level = true
	
	# Allow it to play through after the opening cutscene, but otherwise have no music on main menu
	if $/root/Main/GUI/MainMenu.is_visible() and has_been_in_level:
		stop()

func _on_finished() -> void:
	if (!$/root/Main/GUI/MainMenu.is_visible()):
		play()
