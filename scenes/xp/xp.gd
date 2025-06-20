class_name XP extends Node2D

@export var xp_val: int = 1


func _on_area_2d_area_entered(area: Area2D) -> void:
	SignalManager.on_xp_touched.emit(xp_val)
	queue_free()
