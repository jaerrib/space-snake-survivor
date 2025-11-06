class_name UFO extends EnemyBase


func _on_hit_box_area_entered(area: Area2D) -> void:
	var damage = area.get_damage()
	hp -= damage
	if hp <= 0:
		SoundManager.play_sound_at(SoundManager.SoundType.DIE03, global_position)
		var spawn_pos: Vector2 = global_position
		SignalManager.on_create_object.emit(spawn_pos, Constants.ObjectType["XP"], xp_val)
		SignalManager.on_enemy_killed.emit()
		queue_free()
	else:
		SoundManager.play_sound_at(SoundManager.SoundType.ENEMY_HIT, global_position)
		knockback()
