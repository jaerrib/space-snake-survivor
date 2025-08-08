class_name WorldLayer extends Node2D

var active_sectors: Array = []

@onready var sector_1: TileMapLayer = $Sector1
@onready var sector_2: TileMapLayer = $Sector2
@onready var sector_3: TileMapLayer = $Sector3
@onready var sector_4: TileMapLayer = $Sector4
@onready var sector_5: TileMapLayer = $Sector5
@onready var sector_timer: Timer = $SectorTimer


func _ready() -> void:
	active_sectors = [ sector_1, sector_2, sector_3, sector_4, sector_5 ]


func _on_sector_timer_timeout() -> void:
	if active_sectors.size() > 0:
		active_sectors[0].queue_free()
		active_sectors.pop_front()
	else:
		sector_timer.stop()
