class_name EnemySpawner
extends Node2D

@export var time: int = 0

var spawn_list: Array[SpawnInfo] = []
var difficulty_multiplier: float
var sector_multiplier: int = 1


func _ready() -> void:
	SignalManager.on_set_enemies.connect(on_set_enemies)
	SignalManager.on_advance_sector.connect(on_advance_sector)
	SignalManager.on_set_difficulty.connect(on_set_difficulty)


func on_set_enemies(sector: BaseSector) -> void:
	spawn_list = sector.spawns


func on_set_difficulty(difficulty: Constants.Difficulty) -> void:
	difficulty_multiplier = Constants.DIFFICULTY_MODIFIERS[difficulty]


func on_advance_sector() -> void:
	sector_multiplier += 1


func _on_timer_timeout() -> void:
	time += 1
	for spawn_info in spawn_list:
		var spawn_num: int = max(
			roundi((spawn_info.enemy_num + sector_multiplier) * difficulty_multiplier),
			1
			)
		for i in spawn_num:
			var modified_delay: float = max(
				spawn_info.enemy_spawn_delay / (sqrt(sector_multiplier) * difficulty_multiplier),
				0.2
				)
			if spawn_info.spawn_delay_counter < modified_delay:
				spawn_info.spawn_delay_counter += 1
			else:
				spawn_info.spawn_delay_counter = 0
				var position = get_random_position()
				SignalManager.on_create_enemy.emit(position, spawn_info.enemy)


func get_random_position() -> Vector2:
	var player: Snake = get_tree().get_first_node_in_group("player")
	var view_size: Vector2 = get_viewport_rect().size
	var base_distance: float = max(view_size.x, view_size.y) / 4
	var spawn_distance: float = randf_range(base_distance * 1.1, base_distance * 1.4)
	var angle: float = randf_range(0, TAU)
	var offset: Vector2 = Vector2.RIGHT.rotated(angle) * spawn_distance
	return player.global_position + offset
