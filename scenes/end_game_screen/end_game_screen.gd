class_name EndGameScreen
extends Control

@onready var game_stats: Label = $VBoxContainer/GameStats
@onready var rating_label: Label = $VBoxContainer/RatingLabel
@onready var status_label: Label = $VBoxContainer/StatusLabel


func _ready() -> void:
	set_process(false)
	hide()
	SignalManager.on_send_game_stats.connect(on_send_game_stats)
	SignalManager.on_level_complete.connect(on_level_complete)
	SignalManager.on_player_died.connect(on_player_died)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SoundManager.play_ui_sound(SoundDefs.UISoundType.SELECT)
		GameManager.load_main_menu()


func on_send_game_stats(stats: Dictionary) -> void:
	var stats_text: String = ""
	for key in stats.keys():
		var value: String = str(stats[key])
		if key == "Rating":
			rating_label.text = key + ": " + value + "\n"
		else:
			stats_text += key + ": " + value + "\n"
	game_stats.text = stats_text


func on_level_complete() -> void:
	SoundManager.play_ui_sound(SoundDefs.UISoundType.LEVEL_COMPLETE)
	status_label.text = "Level Complete"
	handle_end_game()


func on_player_died() -> void:
	SoundManager.play_ui_sound(SoundDefs.UISoundType.GAME_OVER)
	status_label.text = "Game Over"
	handle_end_game()


func handle_end_game() -> void:
	SoundManager.stop_music()
	SoundManager.stop_alert()
	stop_movables()
	set_process(true)
	show()


func stop_movables():
	for node in get_tree().get_nodes_in_group("movables"):
		node.set_process(false)
		node.set_physics_process(false)
