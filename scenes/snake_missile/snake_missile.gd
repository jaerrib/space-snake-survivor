extends BaseProjectile


func _ready() -> void:
	SoundManager.play_sound_at(SoundDefs.SoundType.SNAKE_MISSILE, global_position)
