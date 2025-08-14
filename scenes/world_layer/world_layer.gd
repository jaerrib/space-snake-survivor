class_name WorldLayer extends Node2D

var active_sectors: Array = []

@onready var sector_1: BaseSector = $Sectors/Sector1
@onready var sector_2: BaseSector = $Sectors/Sector2
@onready var sector_3: BaseSector = $Sectors/Sector3
@onready var sector_4: BaseSector = $Sectors/Sector4
@onready var sector_5: BaseSector = $Sectors/Sector5
@onready var sector_timer: Timer = $SectorTimer


func _ready() -> void:
	active_sectors = [ sector_1, sector_2, sector_3, sector_4, sector_5 ]


func _on_sector_timer_timeout() -> void:
	if active_sectors.size() > 0:
		var walls: TileMapLayer = active_sectors[0].get_node("Walls")
		walls.enabled = false
		active_sectors.pop_front()
	else:
		sector_timer.stop()
