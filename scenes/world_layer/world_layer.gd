class_name WorldLayer extends Node2D

@export var total_sectors: int

var active_sectors: Array = []


func _ready() -> void:
	instantiate_random_sectors()
	call_deferred("_finalize_setup")
	SignalManager.on_snake_grow.connect(on_snake_grow)

func _finalize_setup() -> void:
	active_sectors = get_children()


func on_snake_grow() -> void:
	if active_sectors.size() > 0:
		var forcefield: TileMapLayer = active_sectors[0].get_node("Forcefield")
		forcefield.enabled = false
		active_sectors.pop_front()


func instantiate_random_sectors()  -> void:
	var available: Dictionary = Constants.SECTOR_SCENES.duplicate()
	for i in range(1, total_sectors):
		if available.size() != 0:
			var sector_key: Constants.Sectors = available.keys().pick_random()
			var scene: BaseSector = Constants.SECTOR_SCENES[sector_key].instantiate()
			scene.position.x = i * 960
			call_deferred("add_child", scene)
			available.erase(sector_key)
