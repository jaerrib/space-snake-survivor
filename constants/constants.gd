class_name Constants

const SECTOR_SCENES: Dictionary = {
	Constants.Sectors.SECTOR_2: preload("res://scenes/sectors/sector_2.tscn"),
	Constants.Sectors.SECTOR_3: preload("res://scenes/sectors/sector_3.tscn"),
	Constants.Sectors.SECTOR_4: preload("res://scenes/sectors/sector_4.tscn"),
	Constants.Sectors.SECTOR_5: preload("res://scenes/sectors/sector_5.tscn"),
}

const DIFFICULTY_MODIFIERS: Dictionary = {
	Constants.Difficulty.EASY: 0.75,
	Constants.Difficulty.NORMAL: 1.0,
	Constants.Difficulty.HARD: 1.5,
}

enum EnemyType {
	ASTEROID_SMALL,
	ASTEROID_SMALL_2,
	ASTEROID_MEDIUM,
	ASTEROID_MEDIUM_2,
	ASTEROID_LARGE,
	ALIEN_1,
	ALIEN_2,
	ALIEN_3,
	ALIEN_4,
	ALIEN_5,
	ALIEN_6,
	UFO,
	 }

enum ProjectileType { SNAKE_PROJECTILE_1, BLAST_RADIUS, SNAKE_MISSILE }

enum PlayerWeapons { ATTACK_1, ATTACK_2, ATTACK_3 }

enum ObjectType { XP }

enum Difficulty { EASY, NORMAL, HARD }

enum Sectors {
	SECTOR_1,
	SECTOR_2,
	SECTOR_3,
	SECTOR_4,
	SECTOR_5
}
