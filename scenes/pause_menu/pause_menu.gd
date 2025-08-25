class_name PauseMenu extends Control

@onready var enemy_count_label: Label = $VBoxContainer/EnemyCountLabel
@onready var object_count_label: Label = $VBoxContainer/ObjectCountLabel
@onready var projectile_count_label: Label = $VBoxContainer/ProjectileCountLabel


func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_PAUSED:
			hide()
		Node.NOTIFICATION_UNPAUSED:
			update_debug_labels()
			show()


func update_debug_labels() -> void:
	var object_maker: ObjectMaker = get_tree().root.get_node("Main/Level/ObjectMaker")
	var enemy_count: int = object_maker.get_enemy_count()
	var object_count: int = object_maker.get_object_count()
	var projectile_count: int = object_maker.get_projectile_count()
	enemy_count_label.text = "Enemy Count: " + str(enemy_count)
	object_count_label.text = "Object Count: " + str(object_count)
	projectile_count_label.text = "Projectile Count: " + str(projectile_count)
