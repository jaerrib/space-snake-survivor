class_name HealthBar extends TextureProgressBar

const COLOR_DANGER: Color = Color("#cc0000")
const COLOR_MIDDLE: Color = Color("#ff9900")
const COLOR_GOOD: Color = Color("#33cc33")

@export var start_health: float
@export var level_med: float = start_health * .66
@export var level_low: float= start_health * .33

var player_ref: Snake


func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	start_health = player.get_health()
	max_value = player.get_max_health()
	max_value
	value = start_health
	player_ref = player
	SignalManager.on_level_up.connect(on_level_up)


func _process(delta: float) -> void:
	value = player_ref.get_health()
	set_color()


func set_color() -> void:
	if value < level_low:
		tint_progress = COLOR_DANGER
	elif value < level_med:
		tint_progress = COLOR_MIDDLE
	else:
		tint_progress = COLOR_GOOD


func on_level_up() -> void:
	max_value = player_ref.get_max_health()
