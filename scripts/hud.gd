extends Control

func _ready() -> void:
	$PauseScreen.hide()
	$DeathScreen.hide()

func _process(_delta: float) -> void:
	var level_loaded = get_node_or_null("/root/Main/Level")
	var player: Player = get_node_or_null("/root/Main/Level/PlayerSatellite")
	if player:
		if player.damage_timer > 0.0:
			$DamageFlash.show()
			$DamageFlash.color.a = player.damage_timer / Player.DAMAGE_TIME * 0.5
		else:
			$DamageFlash.hide()
	else:
		$DamageFlash.hide()

	# Player is dead
	if level_loaded and !player and !$PauseScreen.visible:
		$DeathScreen.show()
	else:
		$DeathScreen.hide()

	if level_loaded:
		if Input.is_action_just_pressed("ui_cancel"):
			$PauseScreen.visible = !$PauseScreen.visible
			get_tree().paused = $PauseScreen.visible
	else:
		$PauseScreen.visible = false
		get_tree().paused = false
