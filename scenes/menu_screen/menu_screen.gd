extends Control

func _ready() -> void:
	SoundManager.play_music(-1)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		_on_quit_pressed()
	if (
		Input.is_action_just_pressed("ui_down") or
		Input.is_action_just_pressed("ui_up") or
		Input.is_action_just_pressed("ui_left") or
		Input.is_action_just_pressed("ui_right")
		):
		SoundManager.play_ui_sound(SoundDefs.UISoundType.MENU_MOVE)
	if Input.is_action_just_pressed("ui_accept"):
		SoundManager.play_ui_sound(SoundDefs.UISoundType.SELECT)


func _on_easy_pressed() -> void:
	GameManager.load_game_scene(Constants.Difficulty.EASY)


func _on_normal_pressed() -> void:
	GameManager.load_game_scene(Constants.Difficulty.NORMAL)


func _on_hard_pressed() -> void:
	GameManager.load_game_scene(Constants.Difficulty.HARD)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	GameManager.load_credits_screen()
