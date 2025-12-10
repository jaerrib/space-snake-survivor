class_name BombRadius
extends BaseProjectile


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
