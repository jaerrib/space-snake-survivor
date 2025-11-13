extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	SignalManager.on_advance_sector.connect(on_advance_sector)


func on_advance_sector() -> void:
	animation_player.play("sector_open")
