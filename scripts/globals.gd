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
	var previous_time = load_time(key);
	var current_time = Time.get_unix_time_from_system() - Globals.time_pivot;
	
	if previous_time != -1 and current_time > previous_time:
		return;
		
	var config = ConfigFile.new()
	config.set_value("game_time", key, Time.get_unix_time_from_system() - Globals.time_pivot)
	config.save("user://save.cfg");

func load_time(key):
	var config = ConfigFile.new();
	var error = config.load("user://save.cfg");
	if error == OK:
		var score = config.get_value("game_time", key, -1);
		return score;
	else:
		return -1;
		
func load_lang():
	var config = ConfigFile.new();
	var error = config.load("user://save.cfg");
	if error == OK:
		return config.get_value("localization", "lang", "it");
	else:
		return "it";
		
func save_lang(key):		
	if !(key in ["it", "eng"]):
		return;
	
	var config = ConfigFile.new()
	config.set_value("localization", "lang", key)
	config.save("user://save.cfg");
	TranslationServer.set_locale(Globals.lang);
	
