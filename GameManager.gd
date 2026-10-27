extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_PATH = SAVE_DIR + "save_data.json"

var game_started = false
var last_safe_position = Vector2.ZERO
var max_health: int = 67
var current_health: int = 67
var respawn_health = 20
var deadBoss = {}

func regester_boss_death(boss_id):
	deadBoss[boss_id] = true

func reset_collections():
	pass
