class_name HealthBar extends TextureProgressBar

const COLOR_DANGER: Color = Color("#e01b24")
const COLOR_MIDDLE: Color = Color("#ff7800")
const COLOR_GOOD: Color = Color("#33d17a")

var start_health: float
var level_med: float
var level_low: float = start_health * .33
var player_ref: Snake


func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	player_ref = player
	start_health = player.get_health()
	max_value = player.get_max_health()
	value = start_health
	set_hp_levels()
	set_color()
	SignalManager.on_level_up.connect(on_level_up)
	SignalManager.on_update_health.connect(on_update_health)


func set_color() -> void:
	if value < level_low:
		tint_progress = COLOR_DANGER
	elif value < level_med:
		tint_progress = COLOR_MIDDLE
	else:
		tint_progress = COLOR_GOOD


func on_update_health(hp: float) -> void:
	value = hp
	set_color()


func on_level_up() -> void:
	max_value = player_ref.get_max_health()
	set_hp_levels()


func set_hp_levels() -> void:
	level_med = start_health * .66
	level_low = start_health * .33
