extends Node2D

@onready var music: AudioStreamPlayer = $Music


func _ready() -> void:
	SignalManager.on_player_died.connect(on_player_died)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("xp_spawn"):
		var player: Snake = get_tree().get_first_node_in_group("player")
		var spawn_pos: Vector2 = Vector2(player.global_position.x + 50, player.global_position.y + 50)
		SignalManager.on_create_object.emit(spawn_pos, Constants.ObjectType["XP"])


func on_player_died() -> void:
	music.stop()
