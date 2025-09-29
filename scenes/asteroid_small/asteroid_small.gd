class_name AsteroidSmall extends EnemyBase

@export var sprite_frame: int

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	super._ready()
	sprite_2d.frame = sprite_frame
