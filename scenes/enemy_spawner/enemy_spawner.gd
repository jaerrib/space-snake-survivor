extends Node2D

@export var spawns: Array[SpawnInfo] = []
@export var time: int = 0

func _on_timer_timeout() -> void:
	time += 1
	for spawn_info in spawns:
		if time >= spawn_info.time_start and time <= spawn_info.time_end:
			if spawn_info.spawn_delay_counter < spawn_info.enemy_spawn_delay:
				spawn_info.spawn_delay_counter += 1
			else:
				spawn_info.spawn_delay_counter = 0
				for i in spawn_info.enemy_num:
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
