extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	SignalManager.on_toggle_visual_indicator.connect(on_toggle_visual_indicator)

func on_toggle_visual_indicator(status: bool) -> void:
	if status == true:
		tile_map_layer.show()
	else:
		tile_map_layer.hide()
