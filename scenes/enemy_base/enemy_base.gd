class_name EnemyBase extends CharacterBody2D

@export var movement_speed: float = 20.0
@export var hp: float = 1.0
@export var damage: float = 1.0
@export var xp_val: int = 1

var _seek_player: bool = false

@onready var player: Snake =  get_tree().get_first_node_in_group("player")


func _physics_process(_delta) -> void:
	if player and player.is_inside_tree() and _seek_player:
		var direction: Vector2 = global_position.direction_to(player.global_position)
		velocity = direction * movement_speed
		move_and_slide()


func _on_hit_box_area_entered(area: Area2D) -> void:
	var damage = area.get_damage()
	hp -= damage
	print("HIT BY PLAYER FOR ", damage, " DAMAGE")
	if hp <= 0:	
		var spawn_pos: Vector2 = global_position
		SignalManager.on_create_object.emit(spawn_pos, Constants.ObjectType["XP"], xp_val)
		queue_free()


func get_damage() -> int:
	return damage


func _on_seek_timer_timeout() -> void:
	_seek_player = true
