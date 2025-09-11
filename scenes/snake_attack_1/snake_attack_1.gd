class_name SnakeAttack1 extends Node2D

const MULTIPLIER: float = .1
const MAX_LEVEL: int = 10

@export var damage: float = 6.5
@export var delay_time: float = 1.0
@export var penetration: int = 1
@export var speed_modifier: float = 30

var weapon_level: int = 1
var level_increases: int = 0

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = delay_time
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_player_died.connect(on_player_died_or_level_complete)
	SignalManager.on_level_complete.connect(on_player_died_or_level_complete)


func on_player_died_or_level_complete() -> void:
	timer.stop()


func _on_timer_timeout() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	var player_pos: Vector2 = Vector2(player.global_position.x + 8, player.global_position.y + 8)
	var direction: Vector2 = player.move_direction.normalized()
	var projectile_speed: float = player.speed + speed_modifier
	SignalManager.on_create_projectile.emit(
		player_pos,
		direction,
		projectile_speed,
		damage,
		penetration,
		Constants.ProjectileType.SNAKE_PROJECTILE_1
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
	var scale: float = MULTIPLIER + weapon_level * 0.01
	damage += damage * scale
	speed_modifier += speed_modifier * scale
	delay_time *= (1 - scale * 0.75)
	timer.wait_time = delay_time
	penetration += 1


func get_weapon_stats() -> Dictionary:
	var weapon_stats: Dictionary = {
		"Weapon": "Tongue",
		"Level": weapon_level,
		"Damage": floor(damage * 100) / 100,
		"Speed": floor(speed_modifier * 100) / 100,
		"Cooldown": floor(delay_time * 100) / 100,
		"Penetration": penetration,
		}
	return weapon_stats
