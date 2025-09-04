class_name PauseMenu extends Control

@onready var snake_stats_label: Label = $VBoxContainer/SnakeStatsLabel
@onready var weapon_stats: HBoxContainer = $VBoxContainer/WeaponStats


var weapon_stat_list: Dictionary = {}
var snake: Snake

func _ready() -> void:
	snake =  get_tree().get_first_node_in_group("player")


func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_PAUSED:
			hide()
		Node.NOTIFICATION_UNPAUSED:
			update_snake_stats_label()
			update_weapons_stats()
			show()


func update_snake_stats_label() -> void:
	var snake_stats: Dictionary = snake.get_snake_stats()
	var stats_text: String
	for key in snake_stats.keys():
		var value: String = str(snake_stats[key])
		stats_text += key + ": " + value + "\n"
	snake_stats_label.text = stats_text


func update_weapons_stats() -> void:
	var weapon_manager: WeaponManager = snake.get_node("WeaponManager")
	var weapon_stat_list = weapon_manager.get_weapon_stats()
	var index: int = 0
	for weapon_key in weapon_stat_list.keys():
		index += 1
		var weapon_stats: Dictionary = weapon_stat_list[weapon_key]
		var stats_text: String = ""
		for key in weapon_stats.keys():
			var value: String = str(weapon_stats[key])
			stats_text += key + ": " + value + "\n"
		var label_node = $VBoxContainer/WeaponStats.get_node("WeaponLabel" + str(index))
		label_node.text = stats_text
