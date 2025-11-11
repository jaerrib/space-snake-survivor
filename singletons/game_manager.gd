extends Node

const GROUP_PLAYER: String = "Player"
const GROUP_MOVEABLES: String = "Moveables"
const GROUP_ENEMIES: String = "Enemies"
const MAIN = preload("res://scenes/main/main.tscn")
const MENU_SCREEN = preload("res://scenes/menu_screen/menu_screen.tscn")
const CREDITS = preload("res://scenes/credits_screen/credits_screen.tscn")

@export var difficulty: Constants.Difficulty

var scanlines: bool = true


func load_main_menu() -> void:
	SoundManager.stop_music()
	SoundManager.stop_alert()
	get_tree().change_scene_to_packed(MENU_SCREEN)


func load_game_scene(diff_value: Constants.Difficulty) -> void:
	difficulty = diff_value
	get_tree().change_scene_to_packed(MAIN)


func get_difficulty() -> Constants.Difficulty:
	return difficulty


func load_credits_screen() -> void:
	get_tree().change_scene_to_packed(CREDITS)
