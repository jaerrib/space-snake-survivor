class_name Neuropticlord extends EnemyBase

var _projectile_speed: float = 70.0
var _projectile_dmg: float = 20.0
var _attack_penetration: float = 5.0
@onready var eyelid: AnimatedSprite2D = $Eyelid
@onready var stalks: AnimatedSprite2D = $Stalks

func _on_shoot_timer_timeout() -> void:
	stalks.stop()
	eyelid.play("blink")

func _on_eyelid_animation_finished() -> void:
	var direction = global_position.direction_to(player.global_position)
	var shoot_position: Vector2 = Vector2(global_position.x, global_position.y)
	velocity = direction * movement_speed
	SignalManager.on_create_projectile.emit(
		shoot_position,
		direction,
		_projectile_speed,
		_projectile_dmg,
		_attack_penetration,
		Constants.ProjectileType.CYBERBALL
	)
	stalks.play("flail")
