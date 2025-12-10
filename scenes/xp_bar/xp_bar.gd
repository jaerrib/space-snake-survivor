class_name XPBar
extends TextureProgressBar

const XP_COLOR: Color = Color("#3584e4")

var player_ref: Snake
var current_xp: int


func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	player_ref = player
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_update_xp.connect(on_update_xp)
	min_value = 0
	tint_progress = XP_COLOR
	set_xp_levels()


func on_level_up() -> void:
	set_xp_levels()


func on_update_xp() -> void:
	value = player_ref.get_xp()


func set_xp_levels() -> void:
	max_value = player_ref.get_xp_required_for_next_level()
	value = player_ref.get_xp()
