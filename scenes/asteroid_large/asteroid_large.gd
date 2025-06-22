class_name AsteroidLarge extends EnemyBase

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var frame_number: int = randi_range(2, 3)
	sprite_2d.frame = frame_number

func _on_hit_box_area_entered(area: Area2D) -> void:
	var spawn_pos_1: Vector2 = Vector2(global_position.x + 30, global_position.y)
	var spawn_pos_2: Vector2 = Vector2(global_position.x - 30, global_position.y)
	SignalManager.on_create_enemy.emit(spawn_pos_1, Constants.EnemyType.ASTEROID_MEDIUM)
	SignalManager.on_create_enemy.emit(spawn_pos_2, Constants.EnemyType.ASTEROID_MEDIUM)
	queue_free()
