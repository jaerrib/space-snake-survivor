extends Control


func _on_button_pressed() -> void:
	SoundManager.play_ui_sound(SoundDefs.UISoundType.SELECT)
	GameManager.load_main_menu()
