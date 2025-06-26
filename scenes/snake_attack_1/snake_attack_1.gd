class_name SnakeAttack1 extends Node2D

@export var damage: float = 1.0
@export var delay_time: float = 3.0
@export var penetration: int = 1
@export var speed_modifier: float = 30

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = delay_time
	SignalManager.on_level_up.connect(on_level_up)


func _on_timer_timeout() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	var player_pos: Vector2 = Vector2(player.global_position.x + 4, player.global_position.y + 4)
	var direction: Vector2 = player.move_direction
	var projectile_speed: float = player.speed + speed_modifier
	SignalManager.on_create_projectile.emit(
		player_pos,
		direction,
		projectile_speed,
		true,
		damage,
		penetration,
		Constants.ProjectileType.SNAKE_PROJECTILE_1
	)


func on_level_up() -> void:
	damage *= 1.02
	delay_time *= 0.99
	speed_modifier *= 1.02
	var player: Snake = get_tree().get_first_node_in_group("player")
	if player.get_level() % 5 == 0:
		penetration += 1
