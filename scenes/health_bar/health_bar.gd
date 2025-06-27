class_name HealthBar extends TextureProgressBar

const COLOR_DANGER: Color = Color("#cc0000")
const COLOR_MIDDLE: Color = Color("#ff9900")
const COLOR_GOOD: Color = Color("#33cc33")

@export var level_low: float
@export var level_med: float
@export var max_health: float
@export var start_health: float

func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	start_health = player.get_health()
	max_health = player.get_max_health()
	level_med = start_health * .66
	level_med = start_health * .33
