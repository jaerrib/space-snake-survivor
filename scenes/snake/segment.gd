class_name Segment
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_animation_timer: Timer = $DamageAnimationTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var xp_collision_shape_2d: CollisionShape2D = $XpDetection/CollisionShape2D


func _ready() -> void:
	SignalManager.on_rotate_snake.connect(on_rotate_snake)
	SignalManager.on_snake_hit.connect(on_snake_hit)


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


func _on_damage_animation_timer_timeout() -> void:
	animation_player.stop()


func on_snake_hit() -> void:
	damage_animation_timer.start()
	animation_player.play("damaged")
