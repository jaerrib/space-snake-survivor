class_name Neuropticlord extends EnemyBase

var _projectile_speed: float = 50.0
var _projectile_dmg: float = 10.0
var _attack_penetration: float = 1.0
var _is_dead: bool = false

@onready var eyelid: AnimatedSprite2D = $Eyelid
@onready var stalks: AnimatedSprite2D = $Stalks
@onready var hit_box: Area2D = $HitBox
@onready var hurt_box: Area2D = $HurtBox
@onready var shoot_timer: Timer = $ShootTimer
@onready var hurt_collision_shape_2d: CollisionShape2D = $HurtBox/CollisionShape2D


func _ready() -> void:
	super._ready()
	hit_box.set_deferred("monitoring", true)
	hurt_box.set_deferred("monitorable", true)
	death_timer.wait_time = 2.0
	print(damage)


func _on_shoot_timer_timeout() -> void:
	hit_box.set_deferred("monitoring", true)
	stalks.stop()
	eyelid.play("blink")


func _on_eyelid_animation_finished() -> void:
	var direction = global_position.direction_to(player.global_position)
	var shoot_position: Vector2 = Vector2(global_position.x, global_position.y)
	velocity = direction * movement_speed
	SoundManager.play_sound_at(SoundDefs.SoundType.BOSS_SHOOT, global_position)
	SignalManager.on_create_projectile.emit(
		shoot_position,
		direction,
		_projectile_speed,
		_projectile_dmg,
		_attack_penetration,
		Constants.ProjectileType.CYBERBALL
	)
	stalks.play("flail")
	hit_box.set_deferred("monitoring", false)


func _on_hit_box_area_entered(area: Area2D) -> void:
	var incoming_damage = area.get_damage()
	hp -= incoming_damage
	if hp <= 0:
		die()
	else:
		base_animation_player.play("Flash")
		SoundManager.play_sound_at(SoundDefs.SoundType.ENEMY_HIT, global_position)


func die() -> void:
	_is_dead = true
	stalks.stop()
	shoot_timer.stop()
	hit_box.set_deferred("monitoring", false)
	hurt_box.set_deferred("monitorable", false)
	hurt_collision_shape_2d.set_deferred("disabled", true)
	SoundManager.play_sound_at(SoundDefs.SoundType.BOSS_DIE, global_position)
	SignalManager.on_xp_touched.emit(xp_val)
	SignalManager.on_enemy_killed.emit()
	death_timer.start()


func _on_base_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Fade":
		queue_free()
		SignalManager.on_level_complete.emit()


func on_snake_position_update(pos: Vector2) -> void:
	if _is_dead:
		velocity = Vector2(0, 0)
		return
	super.on_snake_position_update(pos)
