extends Node2D

@onready var parent = get_parent()
@onready var solar_system: SolarSystem = $/root/Main/SolarSystem

func _process(_delta: float) -> void:
	var dist = (solar_system.star.position - parent.position).length()
	if dist > 8000.0:
		parent.explode()
