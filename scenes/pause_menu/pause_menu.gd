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
			SoundManager.play_ui_sound(SoundDefs.UISoundType.UNPAUSE)
			hide()
		Node.NOTIFICATION_UNPAUSED:
			SoundManager.play_ui_sound(SoundDefs.UISoundType.PAUSE)
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
		var label_node = $VBoxContainer/WeaponStats.get_node_or_null("WeaponLabel" + str(index))
		if label_node:
			label_node.text = stats_text
			label_node.show()
	set_weapon_label_spacers(index)


func set_weapon_label_spacers(val: int) -> void:
	for num in range(1, val):
		var spacer_node = $VBoxContainer/WeaponStats.get_node_or_null("Spacer" + str(num))
		if spacer_node:
			spacer_node.show()
