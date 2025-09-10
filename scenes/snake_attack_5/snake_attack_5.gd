class_name SnakeAttack5 extends Node2D

const MULTIPLIER: float = .1

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
		var position: Vector2 = get_random_position()
		SignalManager.on_create_projectile.emit(
			position,
			direction,
			speed,
			damage,
			penetration,
			Constants.ProjectileType.SNAKE_FIREBALL
		)


func get_fireball_spawn_position_and_direction() -> Vector2:
	var view_size: Vector2 = get_viewport_rect().size
	var margin: float = 50.0
	var fireball_size: float = 16.0
	var spawn_x: float = randf_range(view_size.x * 0.2, view_size.x + fireball_size)
	var spawn_y: float = -margin
	var spawn_position: Vector2 = Vector2(spawn_x, spawn_y)
	return spawn_position


func get_random_position() -> Vector2:
	var player: Snake = get_tree().get_first_node_in_group("player")
	var view_size: Vector2 = get_viewport_rect().size
	var base_distance: float = max(view_size.x, view_size.y) / 4
	var spawn_distance: float = randf_range(base_distance * 1.1, base_distance * 1.4)
	var angle: float = randf_range(0, TAU)
	var offset: Vector2 = Vector2.RIGHT.rotated(angle) * spawn_distance
	return player.global_position + offset


func on_level_up() -> void:
	if level_increases > 5:
		return
	weapon_level += 1
	if weapon_level % 10 == 0:
		level_increases += 1
		damage += (damage * MULTIPLIER)
		speed += (damage * MULTIPLIER)
		delay_time *= (1 - MULTIPLIER)
		penetration += 1
		num_projectiles += 1


func get_weapon_stats() -> Dictionary:
	var weapon_stats: Dictionary = {
		"Weapon": "Fireballs",
		"Level": weapon_level,
		"Damage": damage,
		"Speed": speed,
		"Cooldown": delay_time,
		"Penetration": penetration,
		"Quantity": num_projectiles,
		}
	return weapon_stats
