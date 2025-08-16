class_name WorldLayer extends Node2D

var active_sectors: Array = []


func _ready() -> void:
	for sector in get_node("Sectors").get_children():
		active_sectors.append(sector)
	SignalManager.on_snake_grow.connect(on_snake_grow)


func on_snake_grow() -> void:
	if active_sectors.size() > 0:
		var forcefield: TileMapLayer = active_sectors[0].get_node("Forcefield")
		forcefield.enabled = false
		active_sectors.pop_front()
