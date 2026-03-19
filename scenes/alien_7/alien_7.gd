class_name Alien7
extends EnemyBase

var _projectile_speed: float = 60.0
var _projectile_dmg: float = 10.0
var _attack_penetration: float = 1.0

@onready var shoot_timer: Timer = $ShootTimer


func _ready() -> void:
	SignalManager.on_player_died.connect(on_player_died_or_level_complete)
	SignalManager.on_level_complete.connect(on_player_died_or_level_complete)


func on_player_died_or_level_complete() -> void:
	shoot_timer.stop()


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
