extends Timer

const LEVEL_LENGTH: int = 1800 #in seconds

@onready var level_timer: Timer = $"."
@onready var label: Label = $"../MC/MC2/HB/Label"


func _ready() -> void:
	level_timer.wait_time = LEVEL_LENGTH
	level_timer.start()


func _process(delta: float) -> void:
	update_label()


func update_label() -> void:
	var time_elapsed: int = int(LEVEL_LENGTH - level_timer.time_left)
	var minutes: int = time_elapsed / 60
	var seconds: int = time_elapsed % 60
	label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
