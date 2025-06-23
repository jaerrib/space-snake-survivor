extends Node2D

const ADD_OBJECT: String = "add_object"

const ENEMY_SCENE: Dictionary = {
	Constants.EnemyType.ASTEROID_SMALL: preload("res://scenes/asteroid_small/asteroid_small.tscn"),
	Constants.EnemyType.ASTEROID_MEDIUM: preload("res://scenes/asteroid_medium/asteroid_medium.tscn"),
	Constants.EnemyType.ASTEROID_LARGE: preload("res://scenes/asteroid_large/asteroid_large.tscn")
}

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.XP: preload("res://scenes/xp/xp.tscn")
}

const PROJECTILE_SCENE: Dictionary = {
	Constants.ProjectileType.SNAKE_PROJECTILE_1: preload("res://scenes/snake_projectile_1/snake_projectile_1.tscn")
}


func _ready() -> void:
	SignalManager.on_create_enemy.connect(on_create_enemy)
	SignalManager.on_create_object.connect(on_create_object)
	SignalManager.on_create_projectile.connect(on_create_projectile)
	
	
func on_create_enemy(position: Vector2, enemy_type: Constants.EnemyType):
	var scene = ENEMY_SCENE[enemy_type].instantiate()
	scene.position = position
	call_deferred("add_child", scene)


func on_create_object(position: Vector2, object_type: Constants.ObjectType) -> void:
	if !OBJECT_SCENES.has(object_type):
		return
	var new_object = OBJECT_SCENES[object_type].instantiate()
	new_object.position = position
	call_deferred("add_child", new_object)


func on_create_projectile(
	start_pos: Vector2,
	direction: Vector2,
	speed: float,
	flip_sprite: bool,
	projectile_type: Constants.ProjectileType ) -> void:
	if !PROJECTILE_SCENE.has(projectile_type):
		return
	var scene = PROJECTILE_SCENE[projectile_type].instantiate()
	scene.position = start_pos
	scene.setup(direction, speed, flip_sprite)
	call_deferred(ADD_OBJECT, scene, start_pos)


func add_object(obj: Node, global_position: Vector2) -> void:
	add_child(obj)
	obj.global_position = global_position
