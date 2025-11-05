extends Node

const SOUND_TYPES: Dictionary = {
	Constants.SoundType.DIE01: preload("res://assets/audio/die01.ogg"),
	Constants.SoundType.DIE02: preload("res://assets/audio/die02.ogg"),
	Constants.SoundType.DIE03: preload("res://assets/audio/die03.ogg"),
	Constants.SoundType.ENEMY_HIT: preload("res://assets/audio/enemy_hit.ogg"),
	Constants.SoundType.STATION_HEAL: preload("res://assets/audio/station_heal.ogg")
}

func play_sound(s_type: Constants.SoundType, audio: AudioStreamPlayer2D):
	audio.stream = SOUND_TYPES[s_type]
	audio.play()
