extends Camera2D

const MIN_ZOOM: float = 1.0
const MAX_ZOOM: float = 4.0

func _process(_delta: float) -> void:
	# Manage camera zoom
	if Input.is_action_just_pressed("zoom_camera_out"):
		zoom *= 0.9
		$/root/Main/Parallax2D.repeat_times = (1 / zoom.x) + 2 # Adjust the background coverage
	elif Input.is_action_just_pressed("zoom_camera_in"):
		zoom *= 1.1
		$/root/Main/Parallax2D.repeat_times = (1 / zoom.x) + 2
	zoom.x = clamp(zoom.x, MIN_ZOOM, MAX_ZOOM)
	zoom.y = zoom.x
