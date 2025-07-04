class_name XP extends Node2D

var _xp_val: int = 1

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	select_sprite()


func _on_area_2d_area_entered(area: Area2D) -> void:
	SignalManager.on_xp_touched.emit(_xp_val)
	queue_free()


func setup(value: int) -> void:
	_xp_val = value


func select_sprite() -> void:
	if _xp_val >= 20:
		sprite_2d.frame = 2
	else:
		if _xp_val >= 10:
			sprite_2d.frame = 1
		else:
			sprite_2d.frame = 0
