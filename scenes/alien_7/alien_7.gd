class_name Alien7
extends EnemyBase

var _projectile_speed: float = 60.0
var _projectile_dmg: float = 10.0
var _attack_penetration: float = 1.0


func _on_shoot_timer_timeout() -> void:
	var direction = global_position.direction_to(player.global_position)
	var shoot_position: Vector2 = Vector2(global_position.x, global_position.y)
	velocity = direction * movement_speed
	SignalManager.on_create_projectile.emit(
		shoot_position,
		direction,
		_projectile_speed,
		_projectile_dmg,
		_attack_penetration,
		Constants.ProjectileType.ALIEN_PROJECTILE
	)
