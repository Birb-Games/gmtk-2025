extends Control

func _ready() -> void:
	$PauseScreen.hide()
	$DeathScreen.hide()
	$WinScreen.hide()

func set_mouse() -> void:
	if $WinScreen.visible or $PauseScreen.visible or !visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _process(_delta: float) -> void:
	set_mouse()

	# Have the screen flash red when the player takes damage
	var level_loaded: Level = get_node_or_null("/root/Main/Level")

	if !level_loaded:
		hide()
		return

	show()
	var enemy_count = level_loaded.get_enemy_count()
	if enemy_count > 0:
		$EnemyCounter.show()
		$EnemyCounter.text = "Enemies Remaining: %d" % enemy_count
	else:
		$EnemyCounter.hide()

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
	if !player and !$PauseScreen.visible and !$WinScreen.visible:
		$DeathScreen.show()
	else:
		$DeathScreen.hide()

	# Check if the player cleared the level
	if level_loaded.cleared and !$DeathScreen.visible:
		if !$PauseScreen.visible:
			$WinScreen.show()
			get_tree().paused = false
		else:
			$WinScreen.hide()

	# Handle pausing
	if Input.is_action_just_pressed("ui_cancel") and !$WinScreen.visible:
		$PauseScreen.visible = !$PauseScreen.visible
		get_tree().paused = $PauseScreen.visible
