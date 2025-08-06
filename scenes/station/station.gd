extends CharacterBody2D

@export var damage_percentage: float = .05

func get_damage() -> int:
	var player_ref: Snake =  get_tree().get_first_node_in_group("player")
	var station_damage = player_ref.get_health() * damage_percentage
	return station_damage
