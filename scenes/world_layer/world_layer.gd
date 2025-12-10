class_name WorldLayer
extends Node2D

const STARTING_LOC: Vector2 = Vector2(-384.0, 176.0)
const SECTOR_WIDTH: int = 960

@export var total_sectors: int
@export var difficulty: Constants.Difficulty

var active_sectors: Array = []

@onready var sector_0: BaseSector = $Sector0
@onready var random_sectors: Node2D = $RandomSectors


func _ready() -> void:
	instantiate_sectors(select_random_sectors())
	SignalManager.on_advance_sector.connect(on_advance_sector)
	call_deferred("_finalize_setup")


func _finalize_setup() -> void:
	active_sectors = random_sectors.get_children()
	sector_0.position = STARTING_LOC
	difficulty = GameManager.get_difficulty()
	SignalManager.on_set_enemies.emit(active_sectors[0])
	SignalManager.on_set_difficulty.emit(difficulty)


func on_advance_sector() -> void:
	if active_sectors.size() > 1:
		var forcefield: TileMapLayer = active_sectors[0].get_node("Forcefield")
		forcefield.enabled = false
		active_sectors.pop_front()
		SignalManager.on_set_enemies.emit(active_sectors[0])


func select_random_sectors()  -> Dictionary:
	var sector_list: Array = range(1, Constants.TOTAL_SECTOR_SCENES + 1)
	sector_list.shuffle()
	var world_list: Dictionary = {}
	for i in range(0, total_sectors):
		var id = sector_list[i]
		var path = "res://scenes/sectors/sector_%d.tscn" % id
		world_list[id] = load(path)
	return world_list


func instantiate_sectors(available: Dictionary) -> void:
	var i: int = 0
	for key in available.keys():
		var value: PackedScene = available[key]
		var scene: BaseSector = value.instantiate()
		scene.position.x = i * SECTOR_WIDTH
		random_sectors.call_deferred("add_child", scene)
		i += 1


func get_current_sector_name() -> String:
	return active_sectors[0].name


func get_total_sectors() -> int:
	return total_sectors


func get_first_level_num() -> int:
	var name: String = get_current_sector_name()
	var parts = name.split("_")
	var number_str = parts[-1]
	var level_number = int(number_str)
	return level_number
