extends Control

const LEVEL_LENGTH: int = 1800 #in seconds
const DIFFICULTY_TEXT: Array = ["EASY", "NORMAL", "HARD"]

@onready var level_timer: Timer = $LevelTimer
@onready var time_label: Label = $MC/MC2/HB/TimeLabel
@onready var xp_level_label: Label = $MC/MC2/HB/XPLevelLabel
@onready var scan_lines: ColorRect = $"../ScanLines"
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

func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	player_ref = player
	xp_level_label.text = str(player_ref.get_level())
	object_maker = get_tree().root.get_node("Main/Level/ObjectMaker")
	world_layer = get_tree().root.get_node("Main/Level/WorldLayer")
	sector_interval = float(LEVEL_LENGTH) / world_layer.get_total_sectors()
	next_sector_time = sector_interval
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_player_died.connect(on_player_died)
	SignalManager.on_advance_sector.connect(on_advance_sector)
	SignalManager.on_enemy_killed.connect(on_enemy_killed)
	debug_info.visible = debug


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle-scanlines"):
		scan_lines.visible = !scan_lines.visible
	if Input.is_action_just_pressed("toggle-debug"):
		toggle_debug()
	if debug:
		update_debug_labels()


func update_timer_label() -> void:
	var minutes: int = time_elapsed / 60
	var seconds: int = time_elapsed % 60
	time_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)


func _on_level_timer_timeout() -> void:
	time_elapsed += 1
	if time_elapsed >= next_sector_time:
		SignalManager.on_advance_sector.emit()
		next_sector_time += sector_interval
	update_timer_label()
	if time_elapsed >= LEVEL_LENGTH:
		SignalManager.on_level_complete.emit()


func on_level_up() -> void:
	xp_level_label.text = str(player_ref.get_level())


func on_player_died() -> void:
	level_timer.stop()


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
	sector_tracker += 1
	sector_level_label.text = "Sector " + str(sector_tracker)
	

func on_enemy_killed() -> void:
	enemies_killed += 1
