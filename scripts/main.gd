extends Node2D

func _process(_delta: float) -> void:
	var homeworld = get_node_or_null("SolarSystem/Homeworld")
	if homeworld != null and homeworld is SpaceObject:
		if homeworld.health > 0.0:
			$Camera2D.position = homeworld.position
