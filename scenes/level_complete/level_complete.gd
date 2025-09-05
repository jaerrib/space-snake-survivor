extends Control


func _ready() -> void:
	set_process(false)
	hide()
	SignalManager.on_level_complete.connect(on_level_complete)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		GameManager.load_main_menu()


func on_level_complete() -> void:
	stop_movables()
	set_process(true)
	show()


func stop_movables():
	for node in get_tree().get_nodes_in_group("movables"):
		node.set_process(false)
		node.set_physics_process(false)
