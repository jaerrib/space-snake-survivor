class_name Station
extends CharacterBody2D

@export var max_supply: float = 100.0
@export var supply: float = 100.0

var player_ref: Snake = null
var heal_amt: float = 0.0

@onready var station_heal_supply: StationHealSupply = $StationHealSupply


func _ready() -> void:
	player_ref =  get_tree().get_first_node_in_group("player")
	station_heal_supply.on_update_supply(supply)


func get_heal_amt() -> float:
	heal_amt = (player_ref.get_max_health() - player_ref.get_health())
	if supply - heal_amt > 0:
		supply -= heal_amt
	else:
		heal_amt = supply
		supply = 0
	return heal_amt


func _on_area_2d_area_entered(_area: Area2D) -> void:
	SignalManager.on_station_entered.emit(get_heal_amt())
	station_heal_supply.on_update_supply(supply)
	if heal_amt > 0:
		SoundManager.play_sound_at(SoundDefs.SoundType.STATION_HEAL, global_position)


func set_supply_levels(sector_num: int) -> void:
	var difficulty = GameManager.get_difficulty()
	var modifier = Constants.DIFFICULTY_MODIFIERS[difficulty]
	max_supply = 100.0 + (sector_num * 30 / modifier)
	supply = max_supply
