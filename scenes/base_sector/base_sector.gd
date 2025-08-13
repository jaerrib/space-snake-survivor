class_name BaseSector extends Node2D

@onready var walls: TileMapLayer = $Walls

func _ready() -> void:
	walls.enabled = true

func drop_walls() -> void:
	walls.enabled = false
