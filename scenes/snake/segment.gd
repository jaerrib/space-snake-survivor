class_name Segment extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	SignalManager.on_rotate_snake.connect(on_rotate_snake)


func on_rotate_snake(move_direction: Vector2) -> void:
	match move_direction:
		Vector2.UP:
			sprite_2d.rotation_degrees = 180
		Vector2.DOWN:
			sprite_2d.rotation_degrees = 0
		Vector2.LEFT:
			sprite_2d.rotation_degrees = 90
		Vector2.RIGHT:
			sprite_2d.rotation_degrees = -90


func _on_hit_box_area_entered(area: Area2D) -> void:
	SignalManager.on_segment_hit.emit(area)
