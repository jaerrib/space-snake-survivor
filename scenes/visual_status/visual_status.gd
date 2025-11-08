extends Node2D

var _player_died: bool = false
var _level_complete: bool = false

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	SignalManager.on_toggle_visual_indicator.connect(on_toggle_visual_indicator)
	SignalManager.on_player_died.connect(on_player_died)
	SignalManager.on_level_complete.connect(on_level_complete)


func on_toggle_visual_indicator(status: bool) -> void:
	if status == true and !_player_died and !_level_complete:
		tile_map_layer.show()
		SoundManager.play_alert(SoundDefs.LoopingSoundType.LOW_HEALTH)
	else:
		tile_map_layer.hide()
		SoundManager.stop_alert()


func on_player_died() -> void:
	_player_died = true


func on_level_complete() -> void:
	_level_complete = true
