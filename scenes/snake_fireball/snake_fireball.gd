class_name SnakeFireball extends BaseProjectile

func _ready() -> void:
	SoundManager.play_sound_at(SoundDefs.SoundType.FIREBALL, global_position)
