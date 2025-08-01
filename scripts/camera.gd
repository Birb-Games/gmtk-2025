extends Camera2D

const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 2.0

func _process(_delta: float) -> void:
	var player = get_node_or_null("/root/Main/Level/PlayerSatellite")
	if player:
		position = player.position
		rotation = player.position.angle() + deg_to_rad(90.0)

	# Manage camera zoom
	if Input.is_action_just_pressed("zoom_camera_out"):
		zoom *= 0.9
	elif Input.is_action_just_pressed("zoom_camera_in"):
		zoom *= 1.1
	# Adjust the background coverage
	$/root/Main/Parallax2D.repeat_times = (1 / zoom.x) * 2.0 + 2
	$/root/Main/Parallax2D.rotation = rotation
	zoom.x = clamp(zoom.x, MIN_ZOOM, MAX_ZOOM)
	zoom.y = zoom.x
