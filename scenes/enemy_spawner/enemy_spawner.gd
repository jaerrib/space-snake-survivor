class_name EnemySpawner
extends Node2D

@export var time: int = 0

var spawn_list: Array[SpawnInfo] = []
var difficulty_multiplier: float
var sector_multiplier: int = 1
var spawn_modifier: float
var delay_modifier: float

@onready var player: Snake =  get_tree().get_first_node_in_group("player")
@onready var timer: Timer = $Timer


func _ready() -> void:
	SignalManager.on_set_enemies.connect(on_set_enemies)
	SignalManager.on_advance_sector.connect(on_advance_sector)
	SignalManager.on_set_difficulty.connect(on_set_difficulty)
	SignalManager.on_player_died.connect(on_player_died_or_level_complete)
	on_set_modifiers()


func on_player_died_or_level_complete() -> void:
	timer.stop()


func on_set_enemies(sector: BaseSector) -> void:
	spawn_list = sector.spawns


func on_set_difficulty(difficulty: Constants.Difficulty) -> void:
	difficulty_multiplier = Constants.DIFFICULTY_MODIFIERS[difficulty]


func on_advance_sector() -> void:
	sector_multiplier += 1
	on_set_modifiers()


func on_set_modifiers() -> void:
	spawn_modifier = log(1 + difficulty_multiplier * sector_multiplier)
	delay_modifier = sqrt(sector_multiplier) * difficulty_multiplier


func _on_timer_timeout() -> void:
	time += 1
	for spawn_info in spawn_list:
		var base_spawn: int = spawn_info.enemy_num
		var scaled_spawn: float = base_spawn * spawn_modifier
		var spawn_num: int = max(roundi(scaled_spawn), 1)
		var modified_delay: float = clamp(
			spawn_info.enemy_spawn_delay / delay_modifier,
			0.5,
			spawn_info.enemy_spawn_delay
		)
		for i in spawn_num:
			if spawn_info.spawn_delay_counter < modified_delay:
				spawn_info.spawn_delay_counter += 1
			else:
				spawn_info.spawn_delay_counter = 0
				var position = get_random_position()
				SignalManager.on_create_enemy.emit(position, spawn_info.enemy)


func get_random_position() -> Vector2:
	var view_size: Vector2 = get_viewport_rect().size
	var base_distance: float = max(view_size.x, view_size.y) / 4
	var spawn_distance: float = randf_range(base_distance * 1.1, base_distance * 1.4)
	var angle: float = randf_range(0, TAU)
	var offset: Vector2 = Vector2.RIGHT.rotated(angle) * spawn_distance
	return player.global_position + offset


func get_sector_multipler() -> int:
	return sector_multiplier
