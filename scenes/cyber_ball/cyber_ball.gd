extends BaseProjectile


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		_penetration -= 1
		check_max_penetation()
