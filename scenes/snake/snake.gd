class_name Snake extends CharacterBody2D

const SEGMENT = preload("res://scenes/snake/segment.tscn")
const SEGMENT_SPACING = 18

var hp: float = 80
var move_direction: Vector2 = Vector2.RIGHT
var move_positions = []
var segments: Array[Segment] = []
var speed: int = 50
var xp_level: int = 1
var xp_points: int = 0

@onready var player_cam: Camera2D = $PlayerCam
@onready var segment_holder: Node = $SegmentHolder
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	SignalManager.on_xp_touched.connect(on_xp_touched)
	SignalManager.on_segment_hit.connect(_on_hit_box_area_entered)


func _physics_process(delta: float) -> void:
	get_input()
	velocity = move_direction * speed
	move_positions.insert(0, position)
	if move_positions.size() > (segments.size() + 2) * SEGMENT_SPACING:
		move_positions.pop_back()
	move_and_slide()
	rotate_sprite()
	SignalManager.on_rotate_snake.emit(move_direction)
	update_segments()


func get_input() -> void:
	if Input.is_action_just_pressed("down") and move_direction != Vector2.UP:
		move_direction = Vector2.DOWN
	elif Input.is_action_just_pressed("up") and move_direction != Vector2.DOWN:
		move_direction = Vector2.UP
	elif Input.is_action_just_pressed("left") and move_direction != Vector2.RIGHT:
		move_direction = Vector2.LEFT
	elif Input.is_action_just_pressed("right") and move_direction != Vector2.LEFT:
		move_direction = Vector2.RIGHT


func rotate_sprite() -> void:
	match move_direction:
		Vector2.UP:
			sprite_2d.rotation_degrees = 180
		Vector2.DOWN:
			sprite_2d.rotation_degrees = 0
		Vector2.LEFT:
			sprite_2d.rotation_degrees = 90
		Vector2.RIGHT:
			sprite_2d.rotation_degrees = -90


func xp_required_for(level: int) -> int:
	return 10 * level * level + 50



func on_xp_touched(val: int) -> void:
	xp_points += val
	while xp_points >= xp_required_for(xp_level):
		xp_points -= xp_required_for(xp_level)
		xp_level += 1
		grow()
		print("LEVEL UP! Now at level ", xp_level)


func grow() -> void:
	var new_segment = SEGMENT.instantiate()
	segment_holder.add_child(new_segment)
	if segments.size() > 0:
		var last_segment = segments[-1]
		new_segment.global_position = last_segment.global_position - (move_direction * SEGMENT_SPACING)
	else:
		new_segment.global_position = global_position - (move_direction * SEGMENT_SPACING)
	segments.append(new_segment)


func update_segments() -> void:
	for i in range(segments.size()):
		var spacing_index = (i + 1) * SEGMENT_SPACING
		if spacing_index < move_positions.size():
			segments[i].global_position = move_positions[spacing_index]


func _on_hit_box_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	var damage = enemy.get_damage()
	hp -= damage
	print("HIT BY ASTEROID FOR ", damage, " DAMAGE")
	if hp <= 0:
		print("DEAD")
