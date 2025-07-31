class_name Debris

extends SpaceObject

const LIFETIME: float = 10.0
var lifetimer_timer: float = LIFETIME

func _process(delta: float) -> void:
	lifetimer_timer -= delta
	simulate_physics(delta)

	if lifetimer_timer < 0.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is SpaceObject and area is not Debris and area is not Asteroid:
		queue_free()
	elif area is Player:
		queue_free()
