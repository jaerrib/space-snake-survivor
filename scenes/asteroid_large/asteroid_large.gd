extends EnemyBase

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var frame_number: int = randi_range(2, 3)
	sprite_2d.frame = frame_number
