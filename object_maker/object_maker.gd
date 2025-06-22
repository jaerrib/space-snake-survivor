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

func _ready() -> void:
	SignalManager.on_create_enemy.connect(on_create_enemy)
	SignalManager.on_create_object.connect(on_create_object)
	
	
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
