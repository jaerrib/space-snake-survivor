class_name Snake
extends CharacterBody2D

const SEGMENT = preload("res://scenes/snake/segment.tscn")
const SEGMENT_SPACING = 24
const XP_DETECTION_MODIFIER: float = 1.022

var current_sector: int = 1
var dmg_reduction: float = 0.0
var hp: float
var hp_regen_amoung: float = 0.1
var max_hp: float = 100
var move_direction: Vector2 = Vector2.RIGHT
var move_positions = []
var segments: Array[Segment] = []
var speed: float = 40
var xp_level: int = 1
var xp_points: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_animation_timer: Timer = $DamageAnimationTimer
@onready var heal_timer: Timer = $HealTimer
@onready var player_cam: Camera2D = $PlayerCam
@onready var position_broadcast_timer: Timer = $PositionBroadcastTimer
@onready var segment_holder: Node = $SegmentHolder
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var xp_collision_shape_2d: CollisionShape2D = $XpDetection/XPCollisionShape2D


func _ready() -> void:
	hp = max_hp
	SignalManager.on_xp_touched.connect(on_xp_touched)
	SignalManager.on_segment_hit.connect(_on_hit_box_area_entered)
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_snake_hit.connect(on_snake_hit)
	SignalManager.on_station_entered.connect(on_station_entered)
	SignalManager.on_snake_grow.connect(on_snake_grow)
	SignalManager.on_advance_sector.connect(on_advance_sector)


func _physics_process(_delta: float) -> void:
	get_input()
	velocity = move_direction * speed
	move_positions.insert(0, position)
	if move_positions.size() > (segments.size() + 2) * SEGMENT_SPACING:
		move_positions.pop_back()
	move_and_slide()
	rotate_sprite()
	check_wall_collision()
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
	return int(10 + pow(level, 1.3))


func on_xp_touched(val: int) -> void:
	xp_points += val
	SignalManager.on_update_xp.emit()
	while xp_points >= xp_required_for(xp_level):
		xp_points -= xp_required_for(xp_level)
		xp_level += 1
		if xp_level % 5 == 0:
			SignalManager.on_snake_grow.emit()
		SignalManager.on_level_up.emit()


func on_snake_grow() -> void:
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
	var damage: float = 0.0
	if area.has_method("get_damage"):
		damage = area.get_damage()
	elif area.get_parent().has_method("get_damage"):
		damage = area.get_parent().get_damage()
	if damage == 0.0:
		return
	var actual_damage: float = damage * (1.0 - dmg_reduction)
	hp = max(hp - actual_damage, 0)
	SignalManager.on_update_health.emit(hp)
	SignalManager.on_snake_hit.emit()
	if hp <= 0:
		SignalManager.on_player_died.emit()


func check_wall_collision() -> void:
	if is_on_wall():
		hp = 0
		SignalManager.on_update_health.emit(hp)
		SignalManager.on_player_died.emit()
		SignalManager.on_snake_hit.emit()


func get_level() -> int:
	return xp_level


func on_level_up() -> void:
	SignalManager.on_create_object.emit(
		global_position,
		Constants.ObjectType.LEVEL_UP,
		0)
	SoundManager.play_ui_sound(SoundDefs.UISoundType.HISS)
	update_max_hp()
	update_regen()
	update_damage_reduction()
	check_for_weapon_add()
	update_xp_detection()


func check_for_weapon_add() -> void:
	if xp_level == 5:
		SignalManager.on_add_weapon.emit(Constants.PlayerWeapons.ATTACK_2)
	elif xp_level == 10:
		SignalManager.on_add_weapon.emit(Constants.PlayerWeapons.ATTACK_3)
	elif xp_level == 15:
		SignalManager.on_add_weapon.emit(Constants.PlayerWeapons.ATTACK_4)
	elif xp_level == 20:
		SignalManager.on_add_weapon.emit(Constants.PlayerWeapons.ATTACK_5)


func on_advance_sector() -> void:
	current_sector += 1
	update_regen()


func update_regen() -> void:
	var base_regen = 0.05 * (current_sector - 1)   # sector scaling
	var bonus_regen = 0.01 * xp_level              # level scaling
	hp_regen_amoung = clamp(0.1 + base_regen + bonus_regen, 0.1, 1.5)


func update_max_hp():
	max_hp = 100 + (xp_level - 1) * 3  # +3 HP per level


func update_damage_reduction():
	var sector_bonus = 0.005 * (current_sector - 1)   # +0.5% per sector
	var level_bonus = 0.001 * xp_level                # +0.1% per level
	dmg_reduction = clamp(sector_bonus + level_bonus, 0.0, 0.25)  # max 25% reduction


func update_xp_detection() -> void:
	xp_collision_shape_2d.shape.radius *= XP_DETECTION_MODIFIER
	for segment in segments:
		segment.xp_collision_shape_2d.shape.radius = xp_collision_shape_2d.shape.radius


func _on_heal_timer_timeout() -> void:
	hp += hp_regen_amoung
	if hp > max_hp:
		hp = max_hp
	SignalManager.on_update_health.emit(hp)


func get_health() -> float:
	return hp


func get_max_health() -> float:
	return max_hp


func get_xp() -> int:
	return xp_points


func get_xp_required_for_next_level() -> int:
	return xp_required_for(xp_level)


func get_snake_stats() -> Dictionary:
	var snake_stats: Dictionary = {
	"Current HP": str(hp).pad_decimals(1),
	"Max HP": max_hp,
	"HP Regen Rate": str(hp_regen_amoung) + "/sec",
	"Dmg Reduction": str(floor(dmg_reduction * 1000) / 1000) + "%",
	"Speed": speed,
	"Current XP": xp_points,
	"Next XP Level": get_xp_required_for_next_level()
	}
	return snake_stats
	

func _on_damage_animation_timer_timeout() -> void:
	animation_player.stop()


func on_snake_hit() -> void:
	SoundManager.play_sound_at(SoundDefs.SoundType.PLAYER_HIT, global_position)
	damage_animation_timer.start()
	animation_player.play("damaged")


func on_station_entered(heal_val: float) -> void:
	hp += heal_val
	if hp > max_hp:
		hp = max_hp
	SignalManager.on_update_health.emit(hp)


func get_last_segment() -> Segment:
	var last_segment = segments[-1]
	return last_segment


func _on_position_broadcast_timer_timeout() -> void:
	SignalManager.on_snake_position_update.emit(global_position)
