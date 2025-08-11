extends Node2D

const ADD_OBJECT: String = "add_object"

const ENEMY_SCENE: Dictionary = {
	Constants.EnemyType.ASTEROID_SMALL: preload("res://scenes/asteroid_small/asteroid_small.tscn"),
	Constants.EnemyType.ASTEROID_SMALL_2: preload("res://scenes/asteroid_small/asteroid_small_2.tscn"),
	Constants.EnemyType.ASTEROID_MEDIUM: preload("res://scenes/asteroid_medium/asteroid_medium.tscn"),
	Constants.EnemyType.ASTEROID_MEDIUM_2: preload("res://scenes/asteroid_medium/asteroid_medium_2.tscn"),
	Constants.EnemyType.ASTEROID_LARGE: preload("res://scenes/asteroid_large/asteroid_large.tscn"),
	Constants.EnemyType.ALIEN_1: preload("res://scenes/alien_1/alien_1.tscn"),
	Constants.EnemyType.ALIEN_2: preload("res://scenes/alien_2/alien_2.tscn"),
	Constants.EnemyType.ALIEN_3: preload("res://scenes/alien_3/alien_3.tscn"),
	Constants.EnemyType.ALIEN_4: preload("res://scenes/alien_4/alien_4.tscn"),
	Constants.EnemyType.ALIEN_5: preload("res://scenes/alien_5/alien_5.tscn"),
	Constants.EnemyType.ALIEN_6: preload("res://scenes/alien_6/alien_6.tscn"),
	Constants.EnemyType.UFO: preload("res://scenes/ufo/ufo.tscn")
}

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.XP: preload("res://scenes/xp/xp.tscn")
}

const PROJECTILE_SCENE: Dictionary = {
	Constants.ProjectileType.SNAKE_PROJECTILE_1: preload("res://scenes/snake_projectile_1/snake_projectile_1.tscn"),
	Constants.ProjectileType.BLAST_RADIUS: preload("res://scenes/blast_radius/blast_radius.tscn"),
	Constants.ProjectileType.SNAKE_MISSILE: preload("res://scenes/snake_missile/snake_missile.tscn")
}


func _ready() -> void:
	SignalManager.on_create_enemy.connect(on_create_enemy)
	SignalManager.on_create_object.connect(on_create_object)
	SignalManager.on_create_projectile.connect(on_create_projectile)
	
	
func on_create_enemy(position: Vector2, enemy_type: Constants.EnemyType):
	var scene = ENEMY_SCENE[enemy_type].instantiate()
	scene.position = position
	call_deferred("add_child", scene)


func on_create_object(position: Vector2, object_type: Constants.ObjectType, value: int) -> void:
	if !OBJECT_SCENES.has(object_type):
		return
	var new_object = OBJECT_SCENES[object_type].instantiate()
	new_object.position = position
	new_object.setup(value)
	call_deferred("add_child", new_object)


func on_create_projectile(
	start_pos: Vector2,
	direction: Vector2,
	speed: float,
	damage: float,
	penetration: int,
	projectile_type: Constants.ProjectileType ) -> void:
	if !PROJECTILE_SCENE.has(projectile_type):
		return
	var scene = PROJECTILE_SCENE[projectile_type].instantiate()
	scene.position = start_pos
	scene.setup(direction, speed, damage, penetration)
	call_deferred(ADD_OBJECT, scene, start_pos)


func add_object(obj: Node, global_position: Vector2) -> void:
	add_child(obj)
	obj.global_position = global_position
