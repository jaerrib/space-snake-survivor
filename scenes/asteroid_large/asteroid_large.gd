class_name AsteroidLarge
extends EnemyBase

var medium_asteroid_type = Constants.EnemyType

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	super._ready()
	var frame_number: int = randi_range(4, 7)
	sprite_2d.frame = frame_number
	determine_medium_asteroid_type()


func _on_hit_box_area_entered(area: Area2D) -> void:
	base_animation_player.play("Flash")
	var incoming_damage = area.get_damage()
	hp -= incoming_damage
	if hp <= 0:
		SoundManager.play_sound_at(SoundDefs.SoundType.DIE02, global_position)
		SignalManager.on_create_object.emit(global_position, Constants.ObjectType["XP"], xp_val)
		var spawn_pos_1: Vector2 = get_random_position()
		var spawn_pos_2: Vector2 = get_random_position()
		SignalManager.on_create_enemy.emit(spawn_pos_1, medium_asteroid_type)
		SignalManager.on_create_enemy.emit(spawn_pos_2, medium_asteroid_type)
		queue_free()
	else:
		SoundManager.play_sound_at(SoundDefs.SoundType.ENEMY_HIT, global_position)
		knockback()


func get_random_position() -> Vector2:
	var angle: float = randf_range(0, TAU)
	var offset: Vector2 = Vector2.RIGHT.rotated(angle) * 17
	return global_position + offset


func determine_medium_asteroid_type() -> void:
	if sprite_2d.frame == 5 or sprite_2d.frame == 7:
		medium_asteroid_type = Constants.EnemyType.ASTEROID_MEDIUM_2
	else:
		medium_asteroid_type = Constants.EnemyType.ASTEROID_MEDIUM
