class_name BombRadius
extends BaseProjectile


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()


func play_bomb_sound() -> void:
		SoundManager.play_sound_at(SoundDefs.SoundType.SNAKE_BOMB, global_position)
