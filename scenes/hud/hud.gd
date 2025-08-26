extends Control

const LEVEL_LENGTH: int = 1800 #in seconds

@onready var level_timer: Timer = $LevelTimer
@onready var time_label: Label = $MC/MC2/HB/TimeLabel
@onready var xp_level_label: Label = $MC/MC2/HB/XPLevelLabel
@onready var scan_lines: ColorRect = $"../ScanLines"
@onready var fps_label: Label = $MarginContainer/FPSLabel



var player_ref: Snake
var time_elapsed: int


func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	player_ref = player
	xp_level_label.text = str(player_ref.get_level())
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_player_died.connect(on_player_died)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle-scanlines"):
		scan_lines.visible = !scan_lines.visible
	fps_label.text = "FPS %d" % Engine.get_frames_per_second()


func update_timer_label() -> void:
	var minutes: int = time_elapsed / 60
	var seconds: int = time_elapsed % 60
	time_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)


func _on_level_timer_timeout() -> void:
	time_elapsed += 1
	update_timer_label()
	if time_elapsed == LEVEL_LENGTH:
		SignalManager.on_level_complete.emit()


func on_level_up() -> void:
	xp_level_label.text = str(player_ref.get_level())


func on_player_died() -> void:
	print("DEAD")
