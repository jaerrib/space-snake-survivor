class_name EnemyBase extends CharacterBody2D

@export var movement_speed: float = 20.0
@export var hp: int = 1

@onready var player: Snake =  get_tree().get_first_node_in_group("player")


func _physics_process(_delta) -> void:
	if player and player.is_inside_tree():
		var direction: Vector2 = global_position.direction_to(player.global_position)
		velocity = direction * movement_speed
		move_and_slide()
