extends Node2D

@onready var music: AudioStreamPlayer = $Music


func _ready() -> void:
	SignalManager.on_player_died.connect(on_player_died_or_level_complete)
	SignalManager.on_level_complete.connect(on_player_died_or_level_complete)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		GameManager.load_main_menu()


func on_player_died_or_level_complete() -> void:
	music.stop()
