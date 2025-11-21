class_name UFO extends EnemyBase


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_hit_box_area_entered(area: Area2D) -> void:
	var damage = area.get_damage()
	hp -= damage
	if hp <= 0:
		SoundManager.play_sound_at(SoundDefs.SoundType.DIE03, global_position)
		var spawn_pos: Vector2 = global_position
		SignalManager.on_create_object.emit(spawn_pos, Constants.ObjectType["XP"], xp_val)
		SignalManager.on_enemy_killed.emit()
		queue_free()
	else:
		base_animation_player.play("Flash")
		SoundManager.play_sound_at(SoundDefs.SoundType.ENEMY_HIT, global_position)
		knockback()


func _on_death_timer_timeout() -> void:
	animated_sprite_2d.play("open")
	SoundManager.play_sound_at(SoundDefs.SoundType.UFO_OPEN, global_position)


func _on_animated_sprite_2d_animation_finished() -> void:
	SignalManager.on_create_enemy.emit(global_position, Constants.EnemyType.ALIEN_7)
	queue_free()
