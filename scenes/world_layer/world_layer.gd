class_name WorldLayer extends Node2D

const STARTING_LOC: Vector2 = Vector2(-384.0, 176.0)

@export var total_sectors: int
@export var difficulty: Constants.Difficulty

var active_sectors: Array = []

@onready var random_sectors: Node2D = $RandomSectors
@onready var starting_sector: BaseSector = $StartingSector


func _ready() -> void:
	instantiate_random_sectors()
	call_deferred("_finalize_setup")
	SignalManager.on_snake_grow.connect(on_snake_grow)


func _finalize_setup() -> void:
	active_sectors = random_sectors.get_children()
	starting_sector.position = STARTING_LOC
	SignalManager.on_set_enemies.emit(active_sectors[0])
	SignalManager.on_set_difficulty.emit(difficulty)


func on_snake_grow() -> void:
	if active_sectors.size() > 1:
		var forcefield: TileMapLayer = active_sectors[0].get_node("Forcefield")
		forcefield.enabled = false
		active_sectors.pop_front()
		SignalManager.on_set_enemies.emit(active_sectors[0])
		SignalManager.on_advance_sector.emit()


func instantiate_random_sectors()  -> void:
	var available: Dictionary = Constants.SECTOR_SCENES.duplicate()
	for i in range(0, total_sectors):
		if available.size() != 0:
			var sector_key: Constants.Sectors = available.keys().pick_random()
			var scene: BaseSector = Constants.SECTOR_SCENES[sector_key].instantiate()
			scene.position.x = i * 960
			random_sectors.call_deferred("add_child", scene)
			available.erase(sector_key)
