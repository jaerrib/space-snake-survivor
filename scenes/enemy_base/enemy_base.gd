class_name EnemyBase extends CharacterBody2D

@export var movement_speed: float = 20.0
@export var hp: float = 1.0
@export var damage: float = 1.0
@export var xp_val: int = 1
@export var knockback_amount: int = 1

var _knocked_back: bool = false
var _knockback_direction: Vector2 = Vector2.ZERO

@onready var player: Snake =  get_tree().get_first_node_in_group("player")
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var fade_animation_player: AnimationPlayer = $FadeAnimationPlayer
@onready var death_timer: Timer = $DeathTimer


func _ready() -> void:
	var enemy_spawner: EnemySpawner = get_tree().get_first_node_in_group("enemy_spawner")
	var sector_multiplier: int = enemy_spawner.get_sector_multipler()
	death_timer.wait_time = clamp(90 / sqrt(sector_multiplier), 30, 90)


func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)


func _on_direction_timer_timeout() -> void:
	if not _knocked_back and player and player.is_inside_tree():
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * movement_speed


func _on_hit_box_area_entered(area: Area2D) -> void:
	var damage = area.get_damage()
	hp -= damage
	if hp <= 0:
		var spawn_pos: Vector2 = global_position
		SignalManager.on_create_object.emit(spawn_pos, Constants.ObjectType["XP"], xp_val)
		queue_free()
	else:
		knockback()


func get_damage() -> int:
	return damage


func knockback() -> void:
	_knockback_direction = (global_position - player.global_position).normalized()
	velocity = _knockback_direction * movement_speed * knockback_amount
	knockback_timer.start()
	_knocked_back = true


func _on_knockback_timer_timeout() -> void:
	_knocked_back = false


func _on_death_timer_timeout() -> void:
	fade_animation_player.play("Fade")


func _on_fade_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
