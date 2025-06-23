extends Node

signal on_create_enemy(position: Vector2, enemy_type: Constants.EnemyType)
signal on_create_object(
	position: Vector2,
	object_type: Constants.ObjectType,
)
signal on_create_projectile(
	position: Vector2, 
	direction: Vector2, 
	speed: float,
	flip_sprite: bool,
	projectile_type: Constants.ProjectileType,
	)
signal on_rotate_snake(direction: Vector2)
signal on_xp_touched(val: int)
