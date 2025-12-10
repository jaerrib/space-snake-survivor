class_name StationHealSupply
extends TextureProgressBar

@export var full: float = 100.0


func _ready() -> void:
	min_value = 0
	value = full


func on_update_supply(val: float) -> void:
	value = val
