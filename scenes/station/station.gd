class_name Station extends CharacterBody2D

@export var damage_percentage: float = .20


func get_damage() -> int:
	var player_ref: Snake =  get_tree().get_first_node_in_group("player")
	var station_damage = player_ref.get_health() * damage_percentage
	return station_damage


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("ENTERED")
	SignalManager.on_snake_heal.emit(damage_percentage)
