class_name SnakeAttack4 extends Node2D

const MULTIPLIER: float = .2
const PROJECT_SPEED: float = 0.0
const MAX_LEVEL: int = 5

@export var damage: float = 5.0
@export var delay_time: float = 5.0
@export var penetration: int = 500

var weapon_level: int = 1
var level_increases: int = 0
var player_ref: Snake

@onready var cooldown_timer: Timer = $CooldownTimer


func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	player_ref = player
	cooldown_timer.wait_time = delay_time
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_player_died.connect(on_player_died_or_level_complete)
	SignalManager.on_level_complete.connect(on_player_died_or_level_complete)


func on_player_died_or_level_complete() -> void:
	cooldown_timer.stop()


func _on_cooldown_timer_timeout() -> void:
	var last_segment = player_ref.get_last_segment()
	var segment_pos: Vector2 = Vector2(last_segment.global_position.x + 8, last_segment.global_position.y + 8)
	SignalManager.on_create_projectile.emit(
		segment_pos,
		Vector2.ZERO,
		PROJECT_SPEED,
		damage,
		penetration,
		Constants.ProjectileType.SNAKE_BOMB
	)


func on_level_up() -> void:
	if weapon_level >= MAX_LEVEL:
		return
	level_increases += 1
	if level_increases % 10 == 0:
		weapon_level += 1
		damage += (damage * MULTIPLIER)
		delay_time *= (1 - MULTIPLIER)


func get_weapon_stats() -> Dictionary:
	var weapon_stats: Dictionary = {
		"Weapon": "Bomb",
		"Level": weapon_level,
		"Damage": damage,
		"Speed": "N/A",
		"Cooldown": delay_time,
		"Penetration": penetration,
		}
	return weapon_stats
