class_name AsteroidMedium extends EnemyBase

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	var frame_number: int = randi_range(2, 3)
	sprite_2d.frame = frame_number


func _on_hit_box_area_entered(area: Area2D) -> void:
	var damage = area.get_damage()
	hp -= damage
	print("HIT BY PLAYER FOR ", damage, " DAMAGE")
	if hp <= 0:	
		var spawn_pos_1: Vector2 = get_random_position()
		var spawn_pos_2: Vector2 = get_random_position()
		SignalManager.on_create_enemy.emit(spawn_pos_1, Constants.EnemyType.ASTEROID_SMALL)
		SignalManager.on_create_enemy.emit(spawn_pos_2, Constants.EnemyType.ASTEROID_SMALL)
		queue_free()


func get_random_position() -> Vector2:
	var angle: float = randf_range(0, TAU)
	var offset: Vector2 = Vector2.RIGHT.rotated(angle) * 12
	return global_position + offset
