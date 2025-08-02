extends Control

func reset() -> void:
	$PauseScreen.hide()
	$DeathScreen.hide()
	$DeathScreen/VBoxContainer2.show()
	$WinScreen.hide()
	$WinScreen/VBoxContainer2.show()

func _ready() -> void:
	reset()

const BUTTON_DELAY: float = 1.0
var screen_button_timer: float = 0.0
var has_advanced_level: bool = false

func activate_screen(screen: ColorRect) -> void:
	if !screen.visible:
		screen.get_node("VBoxContainer2").hide()
		screen_button_timer = BUTTON_DELAY
	screen.show()

func set_mouse() -> void:
	if $WinScreen.visible or $PauseScreen.visible or !visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _process(delta: float) -> void:
	set_mouse()

	# Have the screen flash red when the player takes damage
	var level_loaded: Level = get_node_or_null("/root/Main/Level")

	if !level_loaded:
		hide()
		return

	if screen_button_timer > 0.0:
		screen_button_timer -= delta

	if $WinScreen.visible and screen_button_timer <= delta:
		$WinScreen/VBoxContainer2.show()
	if $DeathScreen.visible and screen_button_timer <= delta:
		$DeathScreen/VBoxContainer2.show()

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
		activate_screen($DeathScreen)
	else:
		$DeathScreen.hide()

	# Check if the player cleared the level
	if level_loaded.cleared and !$DeathScreen.visible:
		if !$PauseScreen.visible:
			activate_screen($WinScreen)
			get_tree().paused = false
			if !has_advanced_level and $/root/Main.current_level == $/root/Main.levels_unlocked:
				$/root/Main.unlock_next_level()
				$/root/Main.update_current_level(true)
			has_advanced_level = true
		else:
			$WinScreen.hide()
			has_advanced_level = false

	# Handle pausing
	if Input.is_action_just_pressed("ui_cancel") and !$WinScreen.visible:
		$PauseScreen.visible = !$PauseScreen.visible
		get_tree().paused = $PauseScreen.visible

func _on_return_to_main_menu_pressed() -> void:
	var level = get_node_or_null("/root/Main/Level")
	if level:
		level.queue_free()
	
	$/root/Main/GUI/MainMenu.update_continue_button_enabled()
	$/root/Main/GUI/MainMenu.show()
	get_tree().paused = false
	reset()

func _on_restart_pressed() -> void:
	$/root/Main.load_level()

func _on_next_level_pressed() -> void:
	$/root/Main.current_level += 1
	$/root/Main.load_level()
	reset()

