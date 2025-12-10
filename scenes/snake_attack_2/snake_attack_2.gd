class_name SnakeAttack2
extends Node2D

const MULTIPLIER: float = .2
const PROJECT_SPEED: float = 0.0
const MAX_LEVEL: int = 10

@export var damage: float = 5
@export var delay_time: float = 3.0
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
	var player_pos: Vector2 = Vector2(
		player_ref.global_position.x + 8, player_ref.global_position.y + 8
		)
	SignalManager.on_create_projectile.emit(
		player_pos,
		Vector2.ZERO,
		PROJECT_SPEED,
		damage,
		penetration,
		Constants.ProjectileType.BLAST_RADIUS
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
	var adjustment: float = MULTIPLIER + weapon_level * 0.01
	damage += damage * adjustment
	delay_time *= (1 - adjustment * 0.75)
	cooldown_timer.wait_time = delay_time
	penetration += 1


func get_weapon_stats() -> Dictionary:
	var weapon_stats: Dictionary = {
		"Weapon": "Radial Blast",
		"Level": weapon_level,
		"Damage": floor(damage * 100) / 100.0,
		"Cooldown": floor(delay_time * 100) / 100,
		"Penetration": penetration,
		}
	return weapon_stats
