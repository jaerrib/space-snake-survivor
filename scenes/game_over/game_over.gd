extends Control

@onready var game_stats: Label = $VBoxContainer/GameStats


func _ready() -> void:
	set_process(false)
	hide()
	SignalManager.on_send_game_stats.connect(on_send_game_stats)
	SignalManager.on_player_died.connect(on_player_died)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		GameManager.load_main_menu()


func on_send_game_stats(stats: Dictionary) -> void:
	var stats_text: String
	for key in stats.keys():
		var value: String = str(stats[key])
		stats_text += key + ": " + value + "\n"
	game_stats.text = stats_text


func on_player_died() -> void:
	stop_movables()
	set_process(true)
	show()


func stop_movables():
	for node in get_tree().get_nodes_in_group("movables"):
		node.set_process(false)
		node.set_physics_process(false)
