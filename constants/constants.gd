class_name Constants

# Name new sectors in sequential order (1 through n) and increase this value when adding them
const TOTAL_SECTOR_SCENES = 17

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
