extends Camera2D

func _process(_delta: float) -> void:
	# Manage camera zoom
	if Input.is_action_just_pressed("zoom_camera_out"):
		if zoom.x > 0.1: # Prevent zooming out too far
			zoom *= 0.9
			$/root/Main/Parallax2D.repeat_times = (1 / zoom.x) + 2 # Adjust the background coverage
	elif Input.is_action_just_pressed("zoom_camera_in"):
		if zoom.x < 10.0:
			zoom *= 1.1
			$/root/Main/Parallax2D.repeat_times = (1 / zoom.x) + 2
