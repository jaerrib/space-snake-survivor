class_name BaseProjectile extends Area2D

var _damage: int = 1
var _direction: Vector2 = Vector2.ZERO
var _speed: float = 200.0
var _penetration: int = 1

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var removal_timer: Timer = $RemovalTimer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _process(delta: float) -> void:
	position += _direction * _speed * delta


func setup(direction: Vector2, speed: float, damage: int, penetration: int) -> void:
	_direction = direction.normalized()
	_speed = speed
	_damage = damage
	_penetration = penetration


func deactivate () -> void:
	collision_shape_2d.call_deferred("set_disabled", true)


func get_damage() -> int:
	return _damage


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	_penetration -= 1
	check_max_penetation()


func check_max_penetation() -> void:
	if _penetration <= 0:
		set_process(false)
		queue_free()
