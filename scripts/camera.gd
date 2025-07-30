extends Camera2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("zoom_camera_in"):
		zoom *= 0.9
	elif Input.is_action_just_pressed("zoom_camera_out"):
		zoom *= 1.1
