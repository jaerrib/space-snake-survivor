class_name Alien7 extends EnemyBase

var _projectile_speed: float = 50.0
var _attack_penetration: float = 5.0

func _on_shoot_timer_timeout() -> void:
	var direction = global_position.direction_to(player.global_position)
	var shoot_position: Vector2 = Vector2(global_position.x, global_position.y)
	velocity = direction * movement_speed
	SignalManager.on_create_projectile.emit(
		shoot_position,
		direction,
		_projectile_speed,
		damage,
		_attack_penetration,
		Constants.ProjectileType.ALIEN_PROJECTILE
	)
