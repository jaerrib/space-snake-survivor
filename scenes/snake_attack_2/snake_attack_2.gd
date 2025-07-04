class_name SnakeAttack2 extends Node2D

const MULTIPLIER: float = .2
const PROJECT_SPEED: float = 0.0

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


func _on_cooldown_timer_timeout() -> void:
	var player_pos: Vector2 = Vector2(player_ref.global_position.x + 8, player_ref.global_position.y + 8)
	SignalManager.on_create_projectile.emit(
		player_pos,
		Vector2.ZERO,
		PROJECT_SPEED,
		damage,
		penetration,
		Constants.ProjectileType.BLAST_RADIUS
	)



func on_level_up() -> void:
	if level_increases > 5:
		return
	weapon_level += 1
	if weapon_level % 10 == 0:
		level_increases += 1
		damage += (damage * MULTIPLIER)
		delay_time *= (1 - MULTIPLIER)
