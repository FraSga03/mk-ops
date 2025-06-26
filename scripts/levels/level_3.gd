extends Level

@onready var enemy_path: PathFollow3D = $Environment/Floor2/Enemies/Path3D/EnemyPath
@onready var enemy_path_1: PathFollow3D = $Environment/Floor2/Enemies/Path3D2/EnemyPath
@onready var enemy_path_2: PathFollow3D = $Environment/Floor1/Enemies/Path3D/EnemyPath
@onready var enemy_path_3: PathFollow3D = $Environment/Floor1/Enemies/Path3D2/EnemyPath
@onready var enemy_path_4: PathFollow3D = $Environment/Floor3/Enemies/Path3D/EnemyPath
@onready var enemy_path_5: PathFollow3D = $Environment/Floor3/Enemies/Path3D2/EnemyPath

var dialogues = {
	"default": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("3_1K_1"), tr("3_1K_2")],
			[tr("3_1K_3"), tr("3_1K_4")],
		],
		"dialogue_count": 0
	},
	"floor_2_a": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("3_2A_1"), tr("3_2A_2")],
			[tr("3_2A_3")],
		],
		"dialogue_count": 0
	},
	"floor_2_b": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("3_2B_1"), tr("3_2B_2")],
			[tr("3_2B_3")],
		],
		"dialogue_count": 0
	},
	"floor_1_a": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("3_1A_1"), tr("3_1A_2")],
			[tr("3_1A_3"), tr("3_1A_4")]
		],
		"dialogue_count": 0
	},	
	"floor_3_a": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("3_1A_1")],
			[tr("3_1A_2"), tr("3_1A_3")],
		],
		"dialogue_count": 0
	},
	"floor_3_b": {
		"character_name_text": tr("major"),
		"dialogues": [
			[tr("3_3B_1"), tr("3_3B_2")],
			[tr("3_3B_3")],
		],
		"dialogue_count": 0
	},
}

func _init():
	super._init(tr("level_3"), dialogues)

func _on_immovable_exit_door_on_door_entered() -> void:
	Globals.next_scene_info = {
		"current_level_key": "level_3",
		"next_scene": "res://scenes/ui/game_ending.tscn",
		"new_time":  Time.get_unix_time_from_system() - Globals.time_pivot
	}
	
	Globals.save_time("level_3");
	Transition.change_scene("res://scenes/ui/level_completed.tscn");

func set_enemy_path():
	enemy_path.checkpoints = [
		{ "progress": 0.48, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.85, "has_passed": false, "turn_range": 1.2 },
	];
	
	enemy_path_1.checkpoints = [
		{ "progress": 0.1, "has_passed": false, "turn_range": 1.2 },
		{ "progress": 0.52, "has_passed": false, "turn_range": 1.2 },
		{ "progress": 0.6, "has_passed": false, "turn_range": 1.3 },
	];
	
	enemy_path_2.checkpoints = [
		{ "progress": 0.53, "has_passed": false, "turn_range": 1.6 },
		{ "progress": 0.75, "has_passed": false, "turn_range": 1.6 },
	];
	
	enemy_path_3.checkpoints = [
		{ "progress": 0.34, "has_passed": false, "turn_range": 1.5 },
		{ "progress": 0.52, "has_passed": false, "turn_range": 1.5 },
		{ "progress": 0.79, "has_passed": false, "turn_range": 1.5 },
	];
	
	enemy_path_4.checkpoints = [
		{ "progress": 0.23, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.53, "has_passed": false, "turn_range": 1.5 },
		{ "progress": 0.8, "has_passed": false, "turn_range": 1.2 },
	];
	
	enemy_path_5.checkpoints = [
		{ "progress": 0.32, "has_passed": false, "turn_range": 1.3 },
		{ "progress": 0.42, "has_passed": false, "turn_range": 1.4 },
		{ "progress": 0.98, "has_passed": false, "turn_range": 1.8 },
	];

func _on_area_f2a_entered(_body: Node3D) -> void:
	dialogue_key = "floor_2_a";

func _on_area_f2b_entered(_body: Node3D) -> void:
	dialogue_key = "floor_2_b";
	
func _on_area_f1a_entered(_body: Node3D) -> void:
	dialogue_key = "floor_1_a";

func _on_area_f3a_entered(_body: Node3D) -> void:
	dialogue_key = "floor_3_a";

func _on_area_f3b_entered(_body: Node3D) -> void:
	dialogue_key = "floor_3_b";
