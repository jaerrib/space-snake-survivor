class_name SnakeAttack1 extends Node2D

const MULTIPLIER: float = .1

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


func _on_timer_timeout() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	var player_pos: Vector2 = Vector2(player.global_position.x + 8, player.global_position.y + 8)
	var direction: Vector2 = player.move_direction
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
	if level_increases > 5:
		return
	weapon_level += 1
	if weapon_level % 10 == 0:
		level_increases += 1
		damage += (damage * MULTIPLIER)
		speed_modifier += (damage * MULTIPLIER)
		delay_time *= (1 - MULTIPLIER)
		penetration += 1
