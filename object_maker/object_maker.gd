extends Node2D

const ADD_OBJECT: String = "add_object"

const ENEMY_SCENE: Dictionary = {
	Constants.EnemyType.ASTEROID_SMALL: preload("res://scenes/asteroid_small/asteroid_small.tscn"),
	Constants.EnemyType.ASTEROID_MEDIUM: preload("res://scenes/asteroid_medium/asteroid_medium.tscn"),
	Constants.EnemyType.ASTEROID_LARGE: preload("res://scenes/asteroid_large/asteroid_large.tscn")
}


func _ready() -> void:
	SignalManager.on_create_enemy.connect(on_create_enemy)
	
	
func on_create_enemy(position: Vector2, enemy_type: Constants.EnemyType):
	var scene = ENEMY_SCENE[enemy_type].instantiate()
	scene.position = position
	call_deferred("add_child", scene)
