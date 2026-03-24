class_name SnakeAttack5
extends Node2D

const MULTIPLIER: float = .1
const MAX_LEVEL: int = 10

@export var damage: float = 20
@export var delay_time: float = 2.0
@export var penetration: int = 3
@export var speed: float = 100

var weapon_level: int = 1
var level_increases: int = 0
var num_projectiles: int = 3

@onready var cooldown_timer: Timer = $CooldownTimer


func _ready() -> void:
	cooldown_timer.wait_time = delay_time
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_player_died.connect(on_player_died_or_level_complete)
	SignalManager.on_level_complete.connect(on_player_died_or_level_complete)


func on_player_died_or_level_complete() -> void:
	cooldown_timer.stop()


func _on_cooldown_timer_timeout() -> void:
	var direction: Vector2 = Vector2(-1, 1).normalized()
	for i in range(num_projectiles):
		var rand_pos: Vector2 = get_fireball_spawn_position_and_direction()

		SignalManager.on_create_projectile.emit(
			rand_pos,
			direction,
			speed,
			damage,
			penetration,
			Constants.ProjectileType.SNAKE_FIREBALL
		)


func get_fireball_spawn_position_and_direction() -> Vector2:
	var camera: Camera2D = get_viewport().get_camera_2d()
	var view_size: Vector2 = get_viewport_rect().size
	var margin: float = 50.0
	var left_x_limit: float = camera.global_position.x - view_size.x * 0.5
	var right_x_limit: float = camera.global_position.x + view_size.x * 0.5
	var spawn_x: float = randf_range(left_x_limit, right_x_limit)
	var spawn_y: float = camera.global_position.y - view_size.y * 0.5 - margin
	return Vector2(spawn_x, spawn_y)


func on_level_up() -> void:
	level_increases += 1
	var early_scaling: bool = weapon_level < 5 and level_increases % 5 == 0
	var late_scaling: bool = weapon_level >= 5 and level_increases % 10 == 0
	if not (early_scaling or late_scaling):
		return
	if weapon_level >= MAX_LEVEL:
		return
	weapon_level += 1
	var adjustment: float = MULTIPLIER + weapon_level * 0.01
	damage += damage * adjustment
	delay_time *= (1 - adjustment * 0.75)
	cooldown_timer.wait_time = delay_time
	penetration += 1


func get_weapon_stats() -> Dictionary:
	var weapon_stats: Dictionary = {
		"Weapon": "Fireballs",
		"Level": weapon_level,
		"Damage": floor(damage * 100) / 100.0,
		"Cooldown": floor(delay_time * 100) / 100,
		"Penetration": penetration,
		"Quantity": num_projectiles,
		}
	return weapon_stats
