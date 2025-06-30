class_name BlastRadius extends BaseProjectile

var player_ref: Snake

func _ready() -> void:
	var player: Snake = get_tree().get_first_node_in_group("player")
	player_ref = player


func _process(delta: float) -> void:
	position = Vector2(player_ref.global_position.x + 8, player_ref.global_position.y + 8)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
