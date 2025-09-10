class_name WeaponManager extends Node2D

const ADD_WEAPON: String = "add_weapon"


const WEAPON_SCENES: Dictionary = {
	Constants.PlayerWeapons.ATTACK_1: preload("res://scenes/snake_attack_1/snake_attack_1.tscn"),
	Constants.PlayerWeapons.ATTACK_2: preload("res://scenes/snake_attack_2/snake_attack_2.tscn"),
	Constants.PlayerWeapons.ATTACK_3: preload("res://scenes/snake_attack_3/snake_attack_3.tscn"),
	Constants.PlayerWeapons.ATTACK_4: preload("res://scenes/snake_attack_4/snake_attack_4.tscn"),
}

func _ready() -> void:
	SignalManager.on_add_weapon.connect(on_add_weapon)


func on_add_weapon(weapon: Constants.PlayerWeapons) -> void:
	if !WEAPON_SCENES.has(weapon):
		return
	var new_weapon = WEAPON_SCENES[weapon].instantiate()
	call_deferred("add_child", new_weapon)


func get_weapon_stats() -> Dictionary:
	var weapon_list = get_children()
	var weapon_stats: Dictionary = {}
	for weapon in weapon_list:
		var stats: Dictionary = weapon.get_weapon_stats()
		weapon_stats[stats["Weapon"]] = stats
	return weapon_stats
