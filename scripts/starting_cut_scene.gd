extends Control

@export_multiline var text: Array[String]
@export var planet_scales: Array[float]
@export var planet_offsets: Array[float]

var next_planet_scale: float = 0.0
var next_planet_y: float
var current_text_index: int = 0
var button_disable_timer: float = 0.0

func set_text() -> void:
	if current_text_index >= len(text):
		$Label.text = ""
		return
	$Label.text = text[current_text_index]
	if current_text_index < len(planet_scales):
		next_planet_scale = planet_scales[current_text_index]
	if current_text_index < len(planet_offsets):
		next_planet_y = $RoguePlanet.position.y + planet_offsets[current_text_index]

func _ready() -> void:
	$RoguePlanet.scale = Vector2(0.0, 0.0)
	$RoguePlanet.position.x = get_viewport_rect().size.x / 2.0
	$RoguePlanet.position.y = get_viewport_rect().size.y / 2.0 - 240.0
	next_planet_y = $RoguePlanet.position.y
	set_text()

func _on_skip_pressed() -> void:
	hide()
	$/root/Main/GUI/MainMenu.show()

var player_speed: float = 400.0
var enemy_speed: float = 400.0

func _process(delta: float) -> void:
	if !visible:
		return

	if button_disable_timer > 0.0:
		button_disable_timer -= delta
	$Next.disabled = button_disable_timer > 0.0

	if current_text_index >= 3 and $EnemySatellite.position.x < 2000.0:
		$EnemySatellite.position.x += enemy_speed * delta
		enemy_speed += delta * 100.0

	if current_text_index >= len(text):
		$Player.position.y -= delta * player_speed
		player_speed += delta * 100.0

	if $Player.position.y < -250.0:
		hide()
		$/root/Main/GUI/MainMenu.show()
		return

	$RoguePlanet.scale.x += delta * (next_planet_scale - $RoguePlanet.scale.x)
	$RoguePlanet.scale.y = $RoguePlanet.scale.x
	$RoguePlanet.position.y += (next_planet_y - $RoguePlanet.position.y) * delta

func _on_next_pressed() -> void:
	current_text_index += 1
	if current_text_index == len(text) - 1:
		$Next.text = "Start!"	
	elif current_text_index >= len(text):
		$Next.hide()
	set_text()
	button_disable_timer = 1.0
