class_name AsteroidSmall extends EnemyBase

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	var frame_number: int = randi_range(0, 1)
	sprite_2d.frame = frame_number
