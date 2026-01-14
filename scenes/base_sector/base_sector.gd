class_name BaseSector
extends Node2D

@export var spawns: Array[SpawnInfo] = []
@export var has_station: bool = false
@export var sector_num: int

@onready var forcefield: TileMapLayer = $Forcefield
@onready var station: Station = $Objects/Station


func _ready() -> void:
	forcefield.enabled = true
	update_object_positions()
	call_deferred("toggle_station")


func update_object_positions() -> void:
	for object in get_node("Objects").get_children():
		object.position.x += position.x


func toggle_station() -> void:
	if has_station == false:
		station.queue_free()
	else:
		station.set_supply_levels(sector_num)
