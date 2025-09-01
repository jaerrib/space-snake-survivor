extends Control


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		_on_quit_pressed()


func _on_easy_pressed() -> void:
	GameManager.load_game_scene(Constants.Difficulty.EASY)


func _on_normal_pressed() -> void:
	GameManager.load_game_scene(Constants.Difficulty.NORMAL)


func _on_hard_pressed() -> void:
	GameManager.load_game_scene(Constants.Difficulty.HARD)


func _on_quit_pressed() -> void:
	get_tree().quit()


#func _on_credits_pressed() -> void:
	#GameManager.load_credits_screen()
