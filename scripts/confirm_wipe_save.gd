extends Control

@export var starting_cut_scene: PackedScene

func _on_cancel_pressed() -> void:
	hide()
	$/root/Main/GUI/MainMenu.show()

func _on_confirm_pressed() -> void:
	hide()
	var current_cut_scene = $/root/Main/GUI/StartingCutScene
	current_cut_scene.name = "deleted"
	current_cut_scene.queue_free()
	$/root/Main/GUI.add_child(starting_cut_scene.instantiate())
	$/root/Main.reset_save()
