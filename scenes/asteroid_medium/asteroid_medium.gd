class_name AsteroidMedium extends EnemyBase


func _on_hit_box_area_entered(area: Area2D) -> void:
	var spawn_pos_1: Vector2 = Vector2(global_position.x + 30, global_position.y)
	var spawn_pos_2: Vector2 = Vector2(global_position.x - 30, global_position.y)
	SignalManager.on_create_enemy.emit(spawn_pos_1, Constants.EnemyType.ASTEROID_SMALL)
	SignalManager.on_create_enemy.emit(spawn_pos_2, Constants.EnemyType.ASTEROID_SMALL)
	queue_free()
