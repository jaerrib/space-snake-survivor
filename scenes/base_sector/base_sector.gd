class_name BaseSector extends Node2D

@onready var forcefield: TileMapLayer = $Forcefield


func _ready() -> void:
	forcefield.enabled = true
