class_name AsteroidMedium extends EnemyBase

@export var sprite_frame: int

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	super._ready()
	sprite_2d.frame = sprite_frame


func _on_hit_box_area_entered(area: Area2D) -> void:
	var damage = area.get_damage()
	hp -= damage
	if hp <= 0:	
		SoundManager.play_sound_at(SoundDefs.SoundType.DIE02, global_position)
		SignalManager.on_create_object.emit(global_position, Constants.ObjectType["XP"], xp_val)
		var spawn_pos_1: Vector2 = get_random_position()
		var spawn_pos_2: Vector2 = get_random_position()
		SignalManager.on_create_enemy.emit(spawn_pos_1, Constants.EnemyType.ASTEROID_SMALL)
		SignalManager.on_create_enemy.emit(spawn_pos_2, Constants.EnemyType.ASTEROID_SMALL)
		queue_free()
	else:
		SoundManager.play_sound_at(SoundDefs.SoundType.ENEMY_HIT, global_position)
		knockback()


func get_random_position() -> Vector2:
	var angle: float = randf_range(0, TAU)
	var offset: Vector2 = Vector2.RIGHT.rotated(angle) * 12
	return global_position + offset
