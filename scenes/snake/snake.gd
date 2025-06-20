class_name Snake extends CharacterBody2D

var move_direction = Vector2.RIGHT
var speed = 50

@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	get_input()
	velocity = move_direction * speed
	move_and_slide()
	rotate_sprite()


func get_input():
	if Input.is_action_just_pressed("down") and move_direction != Vector2.UP:
		move_direction = Vector2.DOWN
	elif Input.is_action_just_pressed("up") and move_direction != Vector2.DOWN:
		move_direction = Vector2.UP
	elif Input.is_action_just_pressed("left") and move_direction != Vector2.RIGHT:
		move_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("right") and move_direction != Vector2.LEFT:
		move_direction = Vector2.RIGHT


func rotate_sprite():
	match move_direction:
		Vector2.UP:
			sprite_2d.rotation_degrees = 180
		Vector2.DOWN:
			sprite_2d.rotation_degrees = 0
		Vector2.LEFT:
			sprite_2d.rotation_degrees = 90
		Vector2.RIGHT:
			sprite_2d.rotation_degrees = -90
