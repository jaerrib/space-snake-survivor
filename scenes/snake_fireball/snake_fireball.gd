class_name SnakeFireball extends BaseProjectile

func ready() -> void:
	SoundManager.play_sound_at(SoundDefs.SoundType.FIREBALL, global_position)
