class_name SnakeBomb extends BaseProjectile

const PROJECT_SPEED: float = 0.0


func _on_removal_timer_timeout() -> void:
	SignalManager.on_create_projectile.emit(
		global_position,
		Vector2.ZERO,
		PROJECT_SPEED,
		_damage,
		_penetration,
		Constants.ProjectileType.BOMB_RADIUS
	)
	queue_free()
