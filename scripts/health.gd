extends Control

func _process(_delta: float) -> void:
	var level_loaded = get_node_or_null("/root/Main/Level");
	if !level_loaded:
		hide()
		return
	
	show()
	var player: Player = get_node_or_null("/root/Main/Level/PlayerSatellite")
	if player:
		$HealthBar.scale.x = player.get_health_perc()
		$HealthBarPerc.text = "%d%%" % int(floor(player.get_health_perc() * 100.0))
	else:
		$HealthBarPerc.text = "0%"
		$HealthBar.scale.x = 0.0
