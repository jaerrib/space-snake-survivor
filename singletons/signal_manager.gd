extends Node

signal on_create_enemy(position: Vector2, enemy_type: Constants.EnemyType)
signal on_create_object(
	position: Vector2,
	object_type: Constants.ObjectType,
	value: int
)
signal on_create_projectile(
	position: Vector2, 
	direction: Vector2, 
	speed: float,
	flip_sprite: bool,
	damage: float,
	penetration, int,
	projectile_type: Constants.ProjectileType,
	)
signal on_rotate_snake(direction: Vector2)
signal on_xp_touched(val: int)
signal on_segment_hit(area: Area2D)
