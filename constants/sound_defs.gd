class_name SoundDefs extends Resource

enum SoundType {
	DIE01,
	DIE02,
	DIE03,
	ENEMY_HIT,
	STATION_HEAL,
	SECTOR_OPEN,
}

enum UISoundType {
	PAUSE,
	UNPAUSE,
	MENU_MOVE,
	SELECT,
	}

const SOUND_PRIORITIES = {
	SoundType.DIE01: 5,
	SoundType.DIE02: 5,
	SoundType.DIE03: 5,
	SoundType.ENEMY_HIT: 4,
	SoundType.STATION_HEAL: 7,
	SoundType.SECTOR_OPEN: 10,
}

const SOUND_TYPES = {
	SoundType.DIE01: preload("res://assets/audio/fx/die01.ogg"),
	SoundType.DIE02: preload("res://assets/audio/fx/die02.ogg"),
	SoundType.DIE03: preload("res://assets/audio/fx/die03.ogg"),
	SoundType.ENEMY_HIT: preload("res://assets/audio/fx/enemy_hit.ogg"),
	SoundType.STATION_HEAL: preload("res://assets/audio/fx/station_heal.ogg"),
	SoundType.SECTOR_OPEN: preload("res://assets/audio/fx/sector_open.ogg"),
	}

const UI_SOUND_TYPES = {
	UISoundType.PAUSE: preload("res://assets/audio/ui/pause.ogg"),
	UISoundType.UNPAUSE: preload("res://assets/audio/ui/unpause.ogg"),
	UISoundType.MENU_MOVE: preload("res://assets/audio/ui/menu_move.ogg"),
	UISoundType.SELECT: preload("res://assets/audio/ui/select.ogg")
	}

const SOUND_VOLUMES = {
	SoundType.DIE01: 0.8,
	SoundType.DIE02: 0.8,
	SoundType.DIE03: 0.8,
	SoundType.ENEMY_HIT: 1.0,
	SoundType.STATION_HEAL: 0.6,
	SoundType.SECTOR_OPEN: 1.0,
}

const UI_SOUND_VOLUMES = {
	UISoundType.PAUSE: 0.5,
	UISoundType.UNPAUSE: 0.5,
	UISoundType.MENU_MOVE: 0.5,
	UISoundType.SELECT: 0.5,
}
