extends Node

signal on_resume;
signal on_reload_level;

enum MOVEMENT_TYPE {
	WALK,
	CROUCH,
	RUN
}

const MAX_STAMINA = 3;
const MAX_LAUNCH_POWER = 5;

var time_pivot = Time.get_unix_time_from_system();

var next_scene_info = {
	"current_level_key": "level_1",
	"next_scene": "res://scenes/levels/level_2.tscn",
	"new_time": 40000
}

var is_game_over = false;
var current_play_scene = null;
var is_recovering_stamina = false;
var stamina = MAX_STAMINA:
	get:
		return stamina;
	set(value):
		stamina = clamp(value, 0, MAX_STAMINA);
		
var lang = "it":
	get:
		return load_lang();
	set(value):
		save_lang(value)

var launch_power = 1:
	get:
		return launch_power;
	set(value):
		launch_power = clamp(value, 1, 10)

func save_time(key):
	var previous_time = load_time(key)
	var current_time = Time.get_unix_time_from_system() - Globals.time_pivot

	if previous_time != -1 and current_time > previous_time:
		return

	var data = _load_json("user://save.json")
	if not data.has("game_time"):
		data["game_time"] = {}

	data["game_time"][key] = current_time
	_save_json("user://save.json", data)

func load_time(key):
	var data = _load_json("user://save.json")
	if data.has("game_time") and data["game_time"].has(key):
		return data["game_time"][key]
	else:
		return -1

func load_lang():
	var data = _load_json("user://save.json")
	if data.has("localization") and data["localization"].has("lang"):
		return data["localization"]["lang"]
	else:
		return "it"

func save_lang(key):
	if not key in ["it", "eng"]:
		return

	var data = _load_json("user://save.json")
	if not data.has("localization"):
		data["localization"] = {}

	data["localization"]["lang"] = key
	_save_json("user://save.json", data)
	TranslationServer.set_locale(Globals.lang)

func _load_json(path):
	if not FileAccess.file_exists(path):
		_save_json(path, {})

	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY:
			return result
	return {}

func _save_json(path, data):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t")) # Pretty format with tabs
		file.close()
