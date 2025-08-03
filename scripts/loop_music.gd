extends AudioStreamPlayer

@onready var impending_hope: AudioStream = preload("res://assets/music/impending_hope.wav")
@onready var kessler_syndrome = [preload("res://assets/music/kessler_syndrome_opener.wav"), preload("res://assets/music/kessler_syndrome.wav")]

var has_been_in_level: bool = false

func _process(_delta: float) -> void:
	if $/root/Main/GUI/StartingCutScene.is_visible() and !playing:
		play()
	if get_node_or_null("/root/Main/Level") != null:
		has_been_in_level = true
		if !playing:
			var current_track = randi_range(0, 1)
			if current_track == 0:
				stream = impending_hope
			else:
				stream = kessler_syndrome[0]
			play()
	
	# Allow it to play through after the opening cutscene, but otherwise have no music on main menu
	if $/root/Main/GUI/MainMenu.is_visible() and has_been_in_level:
		stop()

func _on_finished() -> void:
	if (!$/root/Main/GUI/MainMenu.is_visible()):
		if stream == kessler_syndrome[0]:
			stream = kessler_syndrome[1]
		play()
