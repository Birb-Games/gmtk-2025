extends Line2D

func _ready() -> void:
	set_as_top_level(true)
	add_point(get_parent().global_position)

func _process(_delta: float) -> void:
	var point = get_parent().global_position	
	var top_point = get_point_position(get_point_count() - 1)
	var dist = (point - top_point).length()
	if dist > 5.0:
		add_point(point)
	if points.size() > 100:
		remove_point(0)
