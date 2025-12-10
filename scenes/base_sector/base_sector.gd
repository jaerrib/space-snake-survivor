class_name BaseSector
extends Node2D

@export var spawns: Array[SpawnInfo] = []

@onready var forcefield: TileMapLayer = $Forcefield


func _ready() -> void:
	forcefield.enabled = true
	update_object_positions()


func update_object_positions() -> void:
	for object in get_node("Objects").get_children():
		object.position.x += position.x
