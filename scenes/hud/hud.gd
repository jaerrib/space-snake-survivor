class_name HUD
extends Control

const LEVEL_LENGTH: int = 1800 #in seconds
const DIFFICULTY_TEXT: Array = ["EASY", "NORMAL", "HARD"]

@onready var level_timer: Timer = $LevelTimer
@onready var time_label: Label = $MC/MC2/HB/TimeLabel
@onready var xp_level_label: Label = $MC/MC2/HB/XPLevelLabel
@onready var debug_info: MarginContainer = $DebugInfo
@onready var fps_label: Label = $DebugInfo/VBoxContainer/FPSLabel
@onready var enemy_count_label: Label = $DebugInfo/VBoxContainer/EnemyCountLabel
@onready var object_count_label: Label = $DebugInfo/VBoxContainer/ObjectCountLabel
@onready var projectile_count_label: Label = $DebugInfo/VBoxContainer/ProjectileCountLabel
@onready var sector_label: Label = $DebugInfo/VBoxContainer/SectorLabel
@onready var difficulty_label: Label = $DebugInfo/VBoxContainer/DifficultyLabel
@onready var sector_level_label: Label = $MC/MC2/HB/SectorLevelLabel

var player_ref: Snake
var time_elapsed: int
var debug: bool = false
var object_maker: ObjectMaker
var world_layer: WorldLayer
var sector_interval: int
var sector_tracker: int = 1
var next_sector_time: float
var enemies_killed: int = 0
var actual_enemies_spawned: int = 0
var dmg_caused: float = 0.0
var dmg_received: float = 0.0
var first_level: int
var _boss_spawned: bool = false

func _ready() -> void:
	_connect_signals()
	call_deferred("on_level_ready")


func on_level_ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	player_ref = player
	xp_level_label.text = str(player_ref.get_level())
	object_maker = get_tree().root.get_node("Main/Level/ObjectMaker")
	world_layer = get_tree().root.get_node("Main/Level/WorldLayer")
	sector_interval = float(LEVEL_LENGTH) / world_layer.get_total_sectors()
	next_sector_time = sector_interval
	debug_info.visible = debug
	first_level = world_layer.get_first_level_num()
	SoundManager.play_music(first_level)


func _connect_signals() -> void:
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_player_died.connect(on_player_died_or_level_complete)
	SignalManager.on_level_complete.connect(on_player_died_or_level_complete)
	SignalManager.on_advance_sector.connect(on_advance_sector)
	SignalManager.on_enemy_killed.connect(on_enemy_killed)
	SignalManager.on_damage_caused.connect(on_damage_caused)
	SignalManager.on_damage_received.connect(on_damage_received)
	SignalManager.on_create_enemy.connect(on_create_enemy)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle-debug"):
		toggle_debug()
	if debug:
		update_debug_labels()


func update_timer_label() -> void:
	time_label.text = get_formated_elapsed_time()


func _on_level_timer_timeout() -> void:
	time_elapsed += 1
	update_timer_label()
	if !_boss_spawned:
		if time_elapsed >= LEVEL_LENGTH:
			SoundManager.play_music(-2)
			var boss_spawn_pos: Vector2 = get_random_position()
			SignalManager.on_create_enemy.emit(boss_spawn_pos, Constants.EnemyType.NEUROPTICLORD)
			_boss_spawned = true
			on_advance_sector()
		if time_elapsed >= next_sector_time:
			SignalManager.on_advance_sector.emit()
			next_sector_time += sector_interval


func get_random_position() -> Vector2:
	var player: Snake =  get_tree().get_first_node_in_group("player")
	var view_size: Vector2 = get_viewport_rect().size
	var base_distance: float = max(view_size.x, view_size.y) / 2
	var spawn_distance: float = randf_range(base_distance * 1.2, base_distance * 1.6)
	var angle: float = randf_range(0, TAU)
	var offset: Vector2 = Vector2.RIGHT.rotated(angle) * spawn_distance
	return player.global_position + offset


func on_level_up() -> void:
	xp_level_label.text = str(player_ref.get_level())


func on_player_died_or_level_complete() -> void:
	level_timer.stop()
	SignalManager.on_send_game_stats.emit(get_game_stats())


func update_debug_labels() -> void:
	fps_label.text = "FPS %d" % Engine.get_frames_per_second()
	enemy_count_label.text = "Enemies %d" % object_maker.get_enemy_count()
	object_count_label.text = "Objects %d" % object_maker.get_object_count()
	projectile_count_label.text = "Projectiles %d" % object_maker.get_projectile_count()
	sector_label.text = world_layer.get_current_sector_name()
	difficulty_label.text = DIFFICULTY_TEXT[(GameManager.get_difficulty())]


func toggle_debug() -> void:
	debug = !debug
	debug_info.visible = !debug_info.visible


func on_advance_sector() -> void:
	SoundManager.play_sound_at(
		SoundDefs.SoundType.SECTOR_OPEN,
		player_ref.global_position
		)
	if _boss_spawned:
		sector_level_label.text = "Neuropticlord Summoned !"
	else:
		sector_tracker += 1
		sector_level_label.text = "Sector " + str(sector_tracker)


func on_enemy_killed() -> void:
	enemies_killed += 1


func get_game_stats() -> Dictionary:
	var rating: Dictionary = calculate_rating()
	var game_stats: Dictionary = {
		"Time Survived": get_formated_elapsed_time(),
		"Sectors Unlocked": sector_tracker,
		"Enemies Spawned": actual_enemies_spawned,
		"Enemies Killed": enemies_killed,
		"Damage Caused": "%0.2f" % dmg_caused,
		"Damage Received": "%0.2f" % dmg_received,
		"Score": rating["score"],
		"Rating": rating["grade"],
		}
	return game_stats


func get_formated_elapsed_time() -> String:
	var minutes: int = time_elapsed / 60
	var seconds: int = time_elapsed % 60
	return str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)


func on_damage_caused(dmg: float) -> void:
	dmg_caused += dmg


func on_damage_received(dmg:float) -> void:
	dmg_received += dmg


func on_create_enemy(_pos, _enemy) -> void:
	actual_enemies_spawned += 1


func calculate_rating() -> Dictionary:
	var survival_time: float = min(time_elapsed / LEVEL_LENGTH, 2.0)
	var sector_progress: float = float(sector_tracker) / (world_layer.total_sectors + 1)
	var kill_efficiency: float = 0.0
	if actual_enemies_spawned > 0:
		kill_efficiency = sqrt(float(enemies_killed) / float(actual_enemies_spawned))
	var damage_ratio: float = 0.0
	if (dmg_caused + dmg_received) > 0:
		damage_ratio = dmg_caused / (dmg_caused + dmg_received)
	var difficulty_bonus: float = 1.0 + (GameManager.get_difficulty() * 0.25) # Easy=1.0, Normal=1.25, Hard=1.5
	var raw_score: float = (
		0.2 * kill_efficiency +
		0.25 * survival_time +
		0.25 * sector_progress +
		0.3 * damage_ratio
		) * difficulty_bonus
	var rating: float = raw_score * 100.0
	var grade: String = ""
	if rating >= 95: grade = "A+"
	elif rating >= 90: grade = "A"
	elif rating >= 85: grade = "A-"
	elif rating >= 80: grade = "B+"
	elif rating >= 75: grade = "B"
	elif rating >= 70: grade = "B-"
	elif rating >= 65: grade = "C+"
	elif rating >= 60: grade = "C"
	elif rating >= 55: grade = "C-"
	elif rating >= 50: grade = "D+"
	elif rating >= 45: grade = "D"
	elif rating >= 40: grade = "D-"
	else: grade = "F"
	return {
		"score": snapped(rating, 0.1),
		"grade": grade
		}
