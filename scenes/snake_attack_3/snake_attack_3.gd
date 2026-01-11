class_name SnakeAttack3
extends Node2D

const MULTIPLIER: float = .1
const MAX_LEVEL: int = 10

@export var damage: float = 20
@export var delay_time: float = 2.0
@export var penetration: int = 1
@export var speed_modifier: float = 50

var weapon_level: int = 1
var level_increases: int = 0
var player_ref: Snake

@onready var initial_timer: Timer = $InitialTimer
@onready var timer: Timer = $Timer


func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	player_ref = player
	timer.wait_time = delay_time
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_player_died.connect(on_player_died_or_level_complete)
	SignalManager.on_level_complete.connect(on_player_died_or_level_complete)
	initial_timer.start()


func on_player_died_or_level_complete() -> void:
	timer.stop()


func _on_timer_timeout() -> void:
	var player_pos: Vector2 = Vector2(
		player_ref.global_position.x + 8, player_ref.global_position.y + 8
		)
	var angle: float = randf_range(0, TAU)
	var random_direction: Vector2 = Vector2.RIGHT.rotated(angle).normalized()
	var projectile_speed: float = player_ref.speed + speed_modifier
	SignalManager.on_create_projectile.emit(
		player_pos,
		random_direction,
		projectile_speed,
		damage,
		penetration,
		Constants.ProjectileType.SNAKE_MISSILE
		)


func on_level_up() -> void:
	level_increases += 1
	var early_scaling: bool = weapon_level < 5 and level_increases % 5 == 0
	var late_scaling: bool = weapon_level >= 5 and level_increases % 10 == 0
	if not (early_scaling or late_scaling):
		return
	if weapon_level >= MAX_LEVEL:
		return
	weapon_level += 1
	var adustment: float = MULTIPLIER + weapon_level * 0.01
	damage += damage * adustment
	speed_modifier += speed_modifier * adustment
	delay_time *= (1 - adustment * 0.75)
	timer.wait_time = delay_time
	penetration += 1


func get_weapon_stats() -> Dictionary:
	var weapon_stats: Dictionary = {
		"Weapon": "Missile",
		"Level": weapon_level,
		"Damage": floor(damage * 100) / 100.0,
		"Speed": floor(speed_modifier * 100) / 100,
		"Cooldown": floor(delay_time * 100) / 100,
		"Penetration": penetration,
		}
	return weapon_stats


func _on_initial_timer_timeout() -> void:
	timer.start()
