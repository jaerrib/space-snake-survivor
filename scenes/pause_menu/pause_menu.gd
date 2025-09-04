class_name PauseMenu extends Control

@onready var snake_stats_label: Label = $VBoxContainer/SnakeStatsLabel


func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_PAUSED:
			hide()
		Node.NOTIFICATION_UNPAUSED:
			update_snake_stats_label()
			show()


func update_snake_stats_label() -> void:
	var snake: Snake =  get_tree().get_first_node_in_group("player")
	var snake_stats: Dictionary = snake.get_snake_stats()
	var stats_text: String
	for key in snake_stats:
		var value: String = str(snake_stats[key])
		stats_text += key + ": " + value + "\n"
	snake_stats_label.text = stats_text
