class_name SoundDefs extends Resource

enum SoundType {
	DIE01,
	DIE02,
	DIE03,
	ENEMY_HIT,
	STATION_HEAL
}

const SOUND_PRIORITIES = {
	SoundType.DIE01: 5,
	SoundType.DIE02: 5,
	SoundType.DIE03: 5,
	SoundType.ENEMY_HIT: 4,
	SoundType.STATION_HEAL: 7
}

const SOUND_TYPES = {
	SoundType.DIE01: preload("res://assets/audio/die01.ogg"),
	SoundType.DIE02: preload("res://assets/audio/die02.ogg"),
	SoundType.DIE03: preload("res://assets/audio/die03.ogg"),
	SoundType.ENEMY_HIT: preload("res://assets/audio/enemy_hit.ogg"),
	SoundType.STATION_HEAL: preload("res://assets/audio/station_heal.ogg")
}

const SOUND_VOLUMES = {
	SoundType.DIE01: 0.8,
	SoundType.DIE02: 0.8,
	SoundType.DIE03: 0.8,
	SoundType.ENEMY_HIT: 1.0,
	SoundType.STATION_HEAL: 0.6
}
