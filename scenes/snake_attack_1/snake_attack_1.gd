class_name SnakeAttack1 extends Node2D

@export var damage: float = 1.0
@export var delay_time: float = 3.0
@export var speed_modifier: float = 30

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = delay_time


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
		Constants.ProjectileType.SNAKE_PROJECTILE_1
	)
