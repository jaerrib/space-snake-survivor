class_name BaseSector extends Node2D

@export var enemy_type: Constants.EnemyType
#@export var enemy_types: Array[Constants.EnemyType] = []


@onready var forcefield: TileMapLayer = $Forcefield


func _ready() -> void:
	forcefield.enabled = true
