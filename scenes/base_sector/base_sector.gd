class_name BaseSector extends Node2D

@export var spawns: Array[SpawnInfo] = []

@onready var forcefield: TileMapLayer = $Forcefield


func _ready() -> void:
	forcefield.enabled = true
